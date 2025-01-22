//
//  SignInAnonymousView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 23.01.25.
//

import SwiftUI

struct SignInAnonymousView: View {
    
    @StateObject private var viewModel = SignInAnonymousViewModel()
    @State var alert: AnyAppAlert? = nil
    @State private var signingIn: Bool = false
    @Binding var showAuthentificationView: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            anonymousLoginButton
        }
        .showCustomAlert(type: .alert, alert: $alert)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var anonymousLoginButton: some View {
        Button {
            print("Anon button pressed")
            Task {
                do {
                    try await viewModel.signInAnonymous()
                    print("signed in anonymously")
                    showAuthentificationView = false
                } catch {
                    alert?.title = error.localizedDescription
                    print("error signed in anonymously")
                }
            }
            
        } label: {
            Text("Sign in Anonymous")
                .font(.headline)
                .foregroundStyle(Color.pink)
                
        }
        
        
    }
}

#Preview {
    SignInAnonymousView(showAuthentificationView: .constant(true))
}
