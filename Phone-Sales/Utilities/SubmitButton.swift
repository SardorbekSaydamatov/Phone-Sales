//
//  SubmitButton.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import Foundation
import SwiftUI

struct SubmitButton: View {
    @State var title: String = "Submit"
    @State var backgroundColor: Color = Color.blue
    var onClick: () -> Void
    var body: some View {
        Button(action: {
            onClick()
        }, label: {
            Text(title)
        })
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(backgroundColor)
        .foregroundStyle(Color.white)
        .cornerRadius(10)
    }
}
