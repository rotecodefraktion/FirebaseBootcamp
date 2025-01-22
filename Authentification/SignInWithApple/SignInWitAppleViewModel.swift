//
//  SignInWitAppleViewModel.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 23.01.25.
//

import SwiftUI

@MainActor
final class SignInWitAppleViewModel: ObservableObject {
    
    let signInWithAppleHelper = AppleSignHelper()
    @Published var didSignInWithApple: Bool = false
    
    
    func signInWithApple() async throws {
        let helper = AppleSignHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthentificationManager.shared.signInWithApple(tokens: tokens)
    }
}
