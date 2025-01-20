//
//  SignInWithAppleButtonView.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 13.01.25.
//

import SwiftUI
import AuthenticationServices

public struct SignInWithAppleView: View {
    public let type: ASAuthorizationAppleIDButton.ButtonType
    public let style: ASAuthorizationAppleIDButton.Style
    public let cornerRadius: CGFloat
    
    public init(
        type: ASAuthorizationAppleIDButton.ButtonType = .signIn,
        style: ASAuthorizationAppleIDButton.Style = .black,
        cornerRadius: CGFloat = 10
    ) {
        self.type = type
        self.style = style
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.001)
            SignInWithAppleViewRepresentable(type: type, style: style, cornerRadius: cornerRadius)
                .disabled(true)
        }
    }
}

private struct SignInWithAppleViewRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    let cornerRadius: CGFloat
    
    func makeUIView(context: Context) -> some UIView {
        let button = ASAuthorizationAppleIDButton(type: type, style: style)
        button.cornerRadius = cornerRadius
        return button
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() {
        
    }
}

#Preview("SignInWithAppleView") {
    ZStack {
        VStack(spacing: 4) {
            SignInWithAppleView(
                type: .signIn,
                style: .black, cornerRadius: 30)
            .frame(height: 50)
        }
        .padding(40)
    }
}

#Preview("SignInWithAppleView_Rectangle") {
    ZStack {
        VStack(spacing: 4) {
            SignInWithAppleView(
                type: .signIn,
                style: .black, cornerRadius: 16)
                .frame(height: 56)
        }
        
    }
}
