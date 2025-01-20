//
//  RootView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 08.01.25.
//

import SwiftUI



@MainActor
struct RootView: View {
    
    @State var showAlert: AnyAppAlert?
    @State var showAutentificationView: Bool = false
    //@State var userAuthenticated: AuthDataResultModel?
    
    var body: some View {
        ZStack {
            NavigationStack {
                if !showAutentificationView {
                    SettingsView(showAuthentificationView: $showAutentificationView)
                }
                
            }
        }
        
        .onAppear {
            let authUser = try? AuthentificationManager.shared.getAuthenticatedUser()
            self.showAutentificationView = authUser == nil
        }
        .showCustomAlert(alert: $showAlert)
        .fullScreenCover(isPresented: $showAutentificationView) {
            NavigationStack {
                AuthentificationView(
                    showAuthentificationView: $showAutentificationView
                )
            }
        }
        
    }
}

#Preview {
    RootView()
}

