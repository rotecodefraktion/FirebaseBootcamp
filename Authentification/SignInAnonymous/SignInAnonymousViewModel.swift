//
//  SignInAnonymousViewModel.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 23.01.25.
//

import SwiftUI

@MainActor
final class SignInAnonymousViewModel: ObservableObject {
    
    func signInAnonymous() async throws {
        try await AuthentificationManager.shared.signInAnonymous()
    }
}
