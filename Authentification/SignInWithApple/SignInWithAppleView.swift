//
//  SignInWithAppleButtonView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 13.01.25.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
    var type: ASAuthorizationAppleIDButton.ButtonType = .signIn
    var style: ASAuthorizationAppleIDButton.Style = .black
    var cornerRadius: CGFloat = 16
    
    @StateObject private var viewModel = SignInWitAppleViewModel()
    @State private var signingIn: Bool = false
    @Binding var showAuthentificationView: Bool
    
    var body: some View {
        Button(
            action: {
                Task {
                    do {
                        try await viewModel.signInWithApple()
                        print("Sign in successful")
                        showAuthentificationView = false
                    } catch {
                        print(error)
                    }
                    signingIn = false
                    
                }
            },
            label: {
                SignInWithAppleViewRepresentable(type: type, style: style, cornerRadius: cornerRadius)
                    .allowsHitTesting(false)
            }
        )
    }
}

#Preview("SignInWithAppleView") {
    ZStack {
        VStack(spacing: 4) {
            SignInWithAppleView(
                type: .signIn,
                style: .black, cornerRadius: 30,
                showAuthentificationView: .constant(true))
            .frame(height: 50)
        }
        .padding(40)
    }
}

#Preview("SignInWithAppleView_Rectangle") {
    ZStack {
        
        Button {
            //
        } label: {
            SignInWithAppleView(
                type: .signIn,
                style: .black, cornerRadius: 16,
                showAuthentificationView: .constant(true))
            .frame(height: 56)
        }
    }
    .padding(40)
}
