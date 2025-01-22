//
//  AppleSignHelper.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 21.01.25.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import UIKit

struct AppleSignInResult {
    let idToken: String
    let nonce: String
    let name: String?
    let email: String?
}

enum AppleSignInError: Error {
    case noTopVC(message: String = "No ViewController found")
    case noIdToken(message: String = "Unable to process Apple ID credential")
    case noAppleSignIn(message: String = "Sign in Error to with Apple account")
}

struct SignInWithAppleViewRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    let cornerRadius: CGFloat
    
    func makeUIView(context: Context) -> some UIView {
        let button = ASAuthorizationAppleIDButton(type: type, style: style)
        button.cornerRadius = cornerRadius
        return button
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() {
        
    }
}

final class AppleSignHelper: NSObject {
    
    private var currentNonce: String?
    private var completionHandler: ((Result<AppleSignInResult, Error>) -> Void)? = nil
    
    @MainActor
    func startSignInWithAppleFlow(uiViewController: UIViewController? = nil) async throws -> AppleSignInResult {
        try await withCheckedThrowingContinuation { continuation in
            self.startSignInWithAppleFlow { result in
                switch result {
                case .success(let signInAppleResult):
                    continuation.resume(returning: signInAppleResult)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
    
    @MainActor
    func startSignInWithAppleFlow(
        uiViewController: UIViewController? = nil,
        completion: @escaping (Result<AppleSignInResult, Error>) -> Void
    ) {
        
        guard let topVC = uiViewController ?? topViewController() else {
            completion(.failure(AppleSignInError.noTopVC()))
            return
        }
        
        let nonce = randomNonceString()
        completionHandler = completion
        
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
}

@available(iOS 13.0, *)
extension AppleSignHelper: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completionHandler?(.failure(AppleSignInError.noIdToken()))
                return
        }
        
        let name = appleIDCredential.fullName?.familyName
        let email = appleIDCredential.email
        
        let tokens = AppleSignInResult(idToken: idTokenString, nonce: nonce, name: name , email: email)
        completionHandler?(.success(tokens))
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple error: \(error)")
        completionHandler?(.failure(AppleSignInError.noAppleSignIn()))
    }
    
}

extension AppleSignHelper {
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        //let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
    
        let controller = controller ?? UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .last { $0.isKeyWindow }?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? self.view as! ASPresentationAnchor
    }
    
}

