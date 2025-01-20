//
//  AuthentificationManager.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 08.01.25.
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    init(uid: String = UUID().uuidString, email: String? = nil, photoUrl: String? = nil) {
        self.uid = uid
        self.email = email
        self.photoUrl = photoUrl
    }
         
}

final class AuthentificationManager {
    static let shared = AuthentificationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            print ("No current User cached")
            throw AuthErrorCode.userNotFound
        }
        print("Current User from Cache found: \(user.email ?? "")")
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        print( "Signing out...")
        try Auth.auth().signOut()
    }
    
}

extension AuthentificationManager {
    
    @discardableResult
    func signIn(with email: String, password: String) async throws -> AuthDataResultModel {
        print ("Signing in...")
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult // Ergebnis muss nicht verwendet werden
    func createUser(with email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        print ("User created successfully, Authentication data: \(authDataResult.user.email ?? "")")
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(with email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
        print ("Password reset email sent successfully")
    }
    
    func updatePassword(with newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            print ("No current User cached")
            throw AuthErrorCode.userNotFound
        }
        try await user.updatePassword(to: newPassword)
        print ("Password updated successfully")
    }
    
    
}

extension AuthentificationManager {
   
    @discardableResult
    func signInWithGoogle(with tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                       accessToken: tokens.accessToken )
        return try await signIn(with: credential)
        
    }
    
    func signIn(with credential: AuthCredential ) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
