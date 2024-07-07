//
//  Binding + Extensions.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 06/07/24.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
    func intBinding() -> Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.wrappedValue) ?? 0
            },
            set: { newValue in
                self.wrappedValue = String(newValue)
            }
        )
    }
}
