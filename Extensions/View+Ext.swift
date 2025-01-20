//
//  View+Ext.swift
//  FirebaseBootcamp
//
//  Created by David Krcek on 08.01.25.
//

import Foundation
import SwiftUI

extension View {
    public func callToActionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.pink)
            .cornerRadius(16)
    }
}


