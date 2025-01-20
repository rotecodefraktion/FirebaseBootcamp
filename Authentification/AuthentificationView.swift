//
//  AuthentificationView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 08.01.25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct AuthentificationView: View {
    
    @Binding var showAuthentificationView: Bool
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            SignInWithGoogleView(
                showAuthentificationView: $showAuthentificationView
            )
            
            SignInWithAppleView(
                type: .signIn,
                style: .black, cornerRadius: 16)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            
            Text("OR")
                .font(.title3)
                .padding(.vertical, 5)
            
            SignInWithEmailView(
                showAutentificationView: $showAuthentificationView)
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(.horizontal,20)
        .navigationTitle("Sign in")
    }
}

#Preview {
        AuthentificationView(showAuthentificationView: .constant(true))
}
