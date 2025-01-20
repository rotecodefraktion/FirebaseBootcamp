//
//  SettingsView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 11.01.25.
//
import SwiftUI
import FirebaseAuth

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut()  throws{
        try  AuthentificationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        if let email = try AuthentificationManager.shared.getAuthenticatedUser().email {
            try await AuthentificationManager.shared.resetPassword(with: email)
        }
    }
    
    func updatePassword(with password: String) async throws {
        try await AuthentificationManager.shared.updatePassword(with: password)
    }
    
    func updateEmail(with newEail: String) async throws {
        try await AuthentificationManager.shared.updatePassword(with: newEail)
    }
}

enum ModalType {
    case passwordChange
    case emailChange
    
    static var `default`: Self { .passwordChange }
}

struct ModalContent  {
    let type: ModalType
    let title: String
    let message: String
    let buttonLabel: String
    
    init(type: ModalType, title: String, message: String, buttonLabel: String){
        self.type = type
        self.title = title
        self.message = message
        self.buttonLabel = buttonLabel
    }
}

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    @State private var alert: AnyAppAlert?
    //@State private var showModal: Bool = false
    @State private var modalContent: ModalContent?
    //@State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var newEmail: String = ""
    @State private var buttonPressed: Bool = false
    @Binding var showAuthentificationView: Bool
   // @Binding var userAuthenticated: AuthDataResultModel?
    
    var body: some View {
        List {
            if let email = try? AuthentificationManager.shared.getAuthenticatedUser().email {
                Section(header: Text("User: \(email)")) {
                    signOutButton
                    
                }
            }
            Section(header: Text("Email functions")) {
                resetPassword
                updatePassword
                updateEmail
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle(Text("Settings"))
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Color.pink)
        
        .showModal(
            isPresented: Binding(isNotNil: $modalContent),
            content: {
                showModalContent(
                    modalContent: $modalContent,
                    changingValue: modalContent?.type == .passwordChange ? $newPassword : $newEmail
                )
            })
        
        .showCustomAlert(type:.alert, alert: $alert)
    }
    
    
    func showModalContent(modalContent: Binding<ModalContent?>, changingValue: Binding<String>) -> some View {

        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.9))
                .frame(height: 250)
                .padding(.horizontal, 40)
            Image(systemName: "xmark")
                .frame(width: 25, height: 25)
                .padding(.trailing, 50)
                .padding(.top, 10)
                .onTapGesture {
                    modalContent.wrappedValue = nil
                }
            VStack(alignment: .center, spacing: 10) {
                Text(modalContent.wrappedValue?.title ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primary)
                    .padding(.bottom, 10)
                Group {
                    if modalContent.wrappedValue?.type == .passwordChange {
                        SecureField("Password", text: changingValue)
                    } else {
                        TextField("Email Address", text: changingValue)
                    }
                }
                .padding()
                .frame(height: 55)
                .background(Color.secondary.opacity(0.3))
                .foregroundColor(Color.primary)
                .cornerRadius(16)
                
                Button {
                    buttonPressed.toggle()
                    Task {
                        print("Start Update")
                        do {
                            try modalContent.wrappedValue?.type == .passwordChange ?
                            await viewModel
                                .updatePassword(with: changingValue.wrappedValue) : await viewModel
                                .updateEmail(with: changingValue.wrappedValue)
                            print ("updated")
                            
                            alert = AnyAppAlert(title: "Success", subtitle: modalContent.wrappedValue?.message, buttons: {
                                AnyView(Button("OK") {
                                    buttonPressed.toggle()
                                    modalContent.wrappedValue = nil
                                })
                            })
                        } catch {
                            print ("Error \(error)")
                            alert = AnyAppAlert(title: "Error", subtitle: "\(error.localizedDescription)")
                            buttonPressed.toggle()
                            modalContent.wrappedValue = nil
                        }
                    }
                    
                } label: {
                    if buttonPressed {
                        ProgressView()
                    } else {
                        Text(modalContent.wrappedValue?.buttonLabel ?? "")
                    }
                    
                }
                .callToActionButton()
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 40)
        }
        .transition(.move(edge: .leading))
        
        
    }
    
    var updatePassword: some View {
        Button("Update Password") {
            modalContent = ModalContent(type: .passwordChange, title: "Set a new password", message: "Password successfully changed", buttonLabel: "Change Password")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    var updateEmail: some View {
        Button("Update Email Address") {
            modalContent = ModalContent(type: .passwordChange, title: "Set a new Email Address ", message: "Email Address successfully changed", buttonLabel: "Change Email Address")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    

    var resetPassword: some View {
        Button {
            Task {
                do {
                    try await viewModel.resetPassword()
                    alert = AnyAppAlert(title: "Reset Password", subtitle: "Please check your email for a link to reset your password.")
                }
                catch {
                    alert?.title="Reset Password Error"
                    alert?.subtitle="\(error)"
                }
            }
        } label: {
            Text("Reset Password")
        }
        
    }
    
    var signOutButton: some View {
        Button {
            Task {
                do {
                    try viewModel.signOut()
                    showAuthentificationView = true
                }
                catch {
                    alert?.title="Logut Error"
                    alert?.subtitle="\(error)"
                }
            }
            
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sign Out")
            }
            
        }
    }
    
    
}
#Preview {
    SettingsView(
        showAuthentificationView: .constant(false))
        //userAuthenticated:.constant(
        //    AuthDataResultModel()
        //)
}
