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
    @State var isLoading: Bool = false

    var body: some View {
        VStack {
            YTextField(text: $userName, placeholder: "Ism")
            YTextField(text: $organization, placeholder: "Do'kon nomi")
            YTextField(text: $email, placeholder: "test@gmail.com")
            YSecureField(text: $password, placeholder: "Parol")
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                SubmitButton(title: "Ro'yhatga olish") {
                    signUpTapped()
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .dismissKeyboardOnTap()
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
        guard !email.isEmpty && !password.isEmpty && !organization.isEmpty && !userName.isEmpty else {
            alertMessage = "Barcha maydonlar to'ldirilishi shart!"
            showAlert = true
            return
        }

        isLoading = true
        Auth.shared.signUp(email: email, name: userName, organizationName: organization, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(_):
                    showMainView = true
                    userName = ""
                    organization = ""
                    email = ""
                    password = ""
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                    userName = ""
                    organization = ""
                    email = ""
                    password = ""
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
