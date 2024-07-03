//
//  CustomCheckBox.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 28/06/24.
//

import Foundation
import SwiftUI

struct CheckboxView: View {
    @Binding var isChecked: Bool
    @State var title: String?

    var body: some View {
        Button(action: {
            self.isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .foregroundColor(isChecked ? .blue : .gray)
                Text(title ?? "Name")
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
