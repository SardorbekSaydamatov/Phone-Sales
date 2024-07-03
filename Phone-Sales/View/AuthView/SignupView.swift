//
//  SignupView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import SwiftUI

struct SignupView: View {
    @State var userName: String = ""
    @State var organization: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var showMainView: Bool = false
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        VStack {
            YTextField(text: $userName, placeholder: "Ism")
            YTextField(text: $organization, placeholder: "Do'kon nomi")
            YTextField(text: $email, placeholder: "test@gmail.com")
            YTextField(text: $password, placeholder: "Parol")
            SubmitButton(title: "Ro'yhatga olish") {
                signUpTapped()
            }
        }
        .padding()
        .navigationDestination(isPresented: $showMainView) {
            ContainerView()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func signUpTapped() {
        if email != "" && password != "", organization != "", userName != "" {
            Auth.shared.signUp(email: email, name: userName, organizationName: organization, password: password) { result in
                switch result {
                case .success(_):
                    showMainView = true
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        } else {
            alertMessage = "Email va parol kiritilishi shart!"
            showAlert = true
        }
    }
}

#Preview {
    SignupView()
}
