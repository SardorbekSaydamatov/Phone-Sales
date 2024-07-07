//
//  Dismisskeyboard.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 06/07/24.
//

import Foundation
import SwiftUI

struct DismissKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                self.hideKeyboard()
            }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
