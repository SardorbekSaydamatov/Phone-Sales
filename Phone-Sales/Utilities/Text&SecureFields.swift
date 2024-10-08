//
//  Utilities.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import Foundation
import SwiftUI

struct YTextField: View {
    
    @Binding var text: String
    @State var placeholder: String = ""
    var color: Color = .blue
    var disabled: Bool = false
    var body: some View {
        
        TextField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .padding(.leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(color)
                )
            .disabled(disabled)
    }
}

#Preview {
    
    YTextField(text: .constant("adc"))
  
}

// MARK: - SecureField

struct YSecureField: View {
    @Binding var text: String
    @State var placeholder = ""
    var body: some View {
        SecureField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .padding(.leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color.blue))
    }
}
