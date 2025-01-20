//
//  Binding+EXT.swift
//  AIChatter
//
//  Created by David Krcek on 03.01.25.
//

import Foundation
import SwiftUI

extension Binding where Value == Bool {
    
    init<T: Sendable>(isNotNil: Binding<T?>) {
        self.init {
            return isNotNil.wrappedValue != nil
        } set: { newValue in
            if !newValue {
               return isNotNil.wrappedValue = nil
            }
        }
        
    }
    
}
