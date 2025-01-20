//
//  FormError.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 14.01.25.
//
import SwiftUI
import FirebaseAuth

enum FormError: Error {
    case invalidEmailPassword
}

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    func resetPassword() async throws {
        if email.isEmpty {
            print ("Empty email")
            throw AuthErrorCode.missingEmail
        }
        
        if !email.isEmpty && ( !email.contains("@") || !email.contains(".") ){
            print ("Invalid email")
            throw AuthErrorCode.invalidEmail
        }
        try await AuthentificationManager.shared.resetPassword(with: self.email)
    }
    
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty  else {
            print("Error")
            throw FormError.invalidEmailPassword
        }
        try await AuthentificationManager.shared.createUser(with: email, password: password)
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty  else {
            print("Error")
            throw FormError.invalidEmailPassword
        }
        _ = try await AuthentificationManager.shared.signIn(with: email, password: password)
        
    }
}
