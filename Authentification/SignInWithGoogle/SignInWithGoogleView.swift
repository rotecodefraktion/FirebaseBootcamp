//
//  SignInWithGoogleView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 13.01.25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift





struct SignInWithGoogleView: View {
    
    @StateObject var viewModel = SignInWithGoogleViewModel()
    @State private var signingIn: Bool = false
    @Binding var showAuthentificationView: Bool
    
    
    var body: some View {
        Button {
            signingIn = true
            Task {
                do {
                    try await viewModel.signInWithGoogle()
                    showAuthentificationView = false
                    print("Sign in successful")
                } catch {
                    print(error)
                }
                signingIn = false
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2), Color.gray.opacity(0.3), Color.gray.opacity(0.4), Color.gray.opacity(0.5)]))
                    .shadow(radius: 2, y: 3)
                RoundedRectangle(cornerRadius: 16).fill(Color.white)
                    .offset(y: 0.75)
                if signingIn {
                    ProgressView()
                } else {
                    HStack {
                        Image("Google Logo")
                            .resizable()
                            .frame(width: 26, height: 26)
                        
                        Text("Sign in with Google")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                        
                    }
                }
            }.zIndex(1)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.horizontal,1)
        }
        .disabled(signingIn)
    }
}

#Preview {
    SignInWithGoogleView(showAuthentificationView: .constant(true))
}
