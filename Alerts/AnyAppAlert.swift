//
//  AnyAppAlert.swift
//  AIChatter
//
//  Created by David Krcek on 03.01.25.
//

import Foundation
import SwiftUI

struct AnyAppAlert: Sendable {
    var title: String
    var subtitle: String?
    var buttons: @Sendable () -> AnyView
    
    init(
        title: String,
        subtitle: String? = nil,
        buttons: (@Sendable () -> AnyView)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.buttons = buttons ?? {
            AnyView(
                Button("OK", action: {
                    //
                })
            )
        }
        
    }
    
    init(error: Error) {
        print("init Error\n")
        self.init(title: "Error", subtitle: error.localizedDescription, buttons: nil)
    }
}

enum AlertType {
    case alert, confirmationDialog
}
extension View {
    
    @ViewBuilder
    func showCustomAlert(type: AlertType = .alert, alert: Binding<AnyAppAlert?>) -> some View {
        
        switch type {
            
        case .alert:
            self
                .alert(
                    alert.wrappedValue?.title ?? "Generel Error",
                    isPresented: Binding(isNotNil: alert)) {
                        alert.wrappedValue?.buttons()
                        
                     //   Button("OK", action: { //alert.wrappedValue = nil
                   // })
                    } message: {
                        if let subtitle = alert.wrappedValue?.subtitle {
                            Text(subtitle)
                        }
                    }
        case .confirmationDialog:
            self
                .confirmationDialog(
                    "",
                    isPresented: Binding(isNotNil: alert)
                ) {
                    Button("Report User/Chat", role: .destructive) {  }
                    Button("Delete Chat", role: .destructive) { }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("What you want to do?")
                }
        }
    }
}
