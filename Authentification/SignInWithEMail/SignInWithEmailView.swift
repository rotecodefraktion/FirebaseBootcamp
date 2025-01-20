//
//  SignInWithEmailView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 08.01.25.
//

import SwiftUI
import FirebaseAuth



struct SignInWithEmailView: View {
    
    @ObservedObject var viewModel = SignInWithEmailViewModel()
    @State var alert: AnyAppAlert? = nil
    @State private var signingIn: Bool = false
    @State var createUser: Bool = true
    @Binding var showAutentificationView: Bool
   // @Binding var userAuthenticated: AuthDataResultModel?
    
    var body: some View {
        VStack(spacing: 10) {
            inputFields
            ctaButton
            loginLink
            resetPasswortLink
        }
        .showCustomAlert(type: .alert, alert: $alert)
        .navigationViewStyle(StackNavigationViewStyle())        
    }
    
    var inputFields: some View {
        Group {
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)
        }
        .padding()
        .frame(height: 56)
        .background(Color.secondary.opacity(0.2))
        .foregroundColor(Color.primary)
        .cornerRadius(16)
    }
    
    var ctaButton: some View {
        Button {
            signingIn.toggle()
            Task {
                print("Calling SignUp")
                do {
                    try await viewModel.signUp()
                    signingIn = false
                    showAutentificationView = false
//                    if let user = try? AuthentificationManager.shared.getAuthenticatedUser() {
//                        userAuthenticated = user
//                        print ("User successdully created")
//                        signingIn = false
//                        showAutentificationView = false
//                        return
//                    }
                } catch {
                    print ("Error \(error)")
                }
                
                do {
                    print("Calling SignIn")
                    try await viewModel.signIn()
                    signingIn = false
                    showAutentificationView = false
//                    if let user = try? AuthentificationManager.shared.getAuthenticatedUser() {
//                        print ("User successdully signed in")
//                        userAuthenticated = user
//                        signingIn = false
//                        showAutentificationView = false
//                    }
                } catch {
                    print ("Error \(error)")
                    alert = AnyAppAlert(title: "Error", subtitle: "\(error.localizedDescription)")
                    signingIn = false
                }
            }
        } label: {
            if signingIn {
                ProgressView()
            } else {
                Text(createUser ? "Create Account" : "Sign In")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
        }
        .callToActionButton()
    }
    
    var loginLink: some View {
        HStack {
            if createUser {
                Text("Already have an account?")
                Text("Login")
                    .font(.body)
                    .foregroundStyle(.pink)
                    .onTapGesture {
                        print("tapped")
                        createUser.toggle()
                    }
            } else {
                Text("No account yet?")
                Text("Create User")
                    .font(.body)
                    .foregroundStyle(.pink)
                    .onTapGesture {
                        print("tapped")
                        createUser.toggle()
                    }
            }
            
        }
    }
    
    var resetPasswortLink: some View {
        Text("Reset your Password")
            .font(.body)
            .underline(true)
            .onTapGesture {
                print("tapped")
                Task {
                    do {
                        try await viewModel.resetPassword()
                        alert = AnyAppAlert(title: "Reset Password", subtitle: "Please check your email for a link to reset your password.")
                    } catch AuthErrorCode.missingEmail {
                        alert = AnyAppAlert(title: "Error", subtitle: "Please type in your email")
                    } catch AuthErrorCode.invalidEmail {
                        alert = AnyAppAlert(title: "Error", subtitle: "\(viewModel.email) isn't a valid email. Please type in a valid email.")
                    } catch {
                        alert = AnyAppAlert(title: "Generell Error", subtitle: "Something went wrong, please try again later")
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        SignInWithEmailView(showAutentificationView: .constant(false) //userAuthenticated: .constant(AuthDataResultModel())
        )
    }
}
