//
//  UIView + Extension.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 06/07/24.
//

import Foundation
import SwiftUI

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardModifier())
    }
}
