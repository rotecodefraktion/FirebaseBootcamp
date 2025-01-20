//
//  ModalSupportView.swift
//  AIChatter
//
//  Created by David Krcek on 04.01.25.
//

import SwiftUI

struct ModalSupportView<Content: View>: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            if isPresented {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.6)
                    .transition(.opacity.animation(.smooth(duration: 0.6)))
                    .onTapGesture {
                        isPresented = false
                    }
                    .zIndex(1)
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                    .zIndex(2)
            }
        }
        .zIndex(9999)
        .animation(Animation.bouncy(duration: 0.5), value: isPresented)
    }
}

extension View {
    
    func showModal(isPresented: Binding<Bool>, @ViewBuilder content: () -> some View) -> some View {
        
        self
            .overlay(
                ModalSupportView(isPresented: isPresented) {
                    content()
                }
            )
    }
    
}

#Preview {
    @Previewable @State var showModal: Bool = false
    
    Button("Show Modal") { showModal.toggle() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .showModal(isPresented: $showModal, content: {
            RoundedRectangle(cornerRadius: 16).fill(Color.black)
                .padding(.vertical, 200)
                .padding(.horizontal, 40)
                .transition(.move(edge: .leading))
        })
        .animation(Animation.bouncy(duration: 0.5), value: showModal)
    
}
