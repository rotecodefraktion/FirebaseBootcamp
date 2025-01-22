//
//  SignInWithGoogleViewModel.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 23.01.25.
//
import SwiftUI

@MainActor
final class SignInWithGoogleViewModel: ObservableObject {
    
    func signInWithGoogle() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        try await AuthentificationManager.shared.signInWithGoogle(with: tokens)
    }
}
