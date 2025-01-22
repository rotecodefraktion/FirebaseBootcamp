//
//  GoogleSignInHelper.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 14.01.25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let email: String
    let name: String
    
}

enum GoogleSignInError: Error {
    case noTopVC(message: String = "No view Controller found")
    case noIdToken(message: String = "No valid ID Token found")
    case noGIDSign(message: String = "No valid GIDSign")
}

final class GoogleSignInHelper {
    
    @MainActor
    func signIn(uiViewController: UIViewController? = nil) async throws -> GoogleSignInResultModel {
        print("Starting sign in")
        guard let topVC = uiViewController ?? topViewController() else {
            throw GoogleSignInError.noTopVC(message: "No TopVC found")
        }
        print("topVC: \(topVC)")
        GIDSignIn.sharedInstance.signOut()
        let gidSignResults = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignResults.user.idToken?.tokenString else {
            throw GoogleSignInError.noIdToken(message: "No valid ID Token found")
        }
        
        let name = gidSignResults.user.profile?.name ?? ""
        let email = gidSignResults.user.profile?.email ?? ""
        
        print("giDSignResults: \(gidSignResults)")
        
        print("token: \(idToken)")
        let accessToken: String = gidSignResults.user.accessToken.tokenString
        
        let tokens: GoogleSignInResultModel = GoogleSignInResultModel(
            idToken: idToken,
            accessToken: accessToken,
            email: email,
            name: name
        )
        
        return tokens
        
        
    }
    
}

extension GoogleSignInHelper {
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
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
