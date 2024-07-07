//
//  ContentView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 26/06/24.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showSignup: Bool = false
    @State var showMainView: Bool = false
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @State var isLoading: Bool = false

    var body: some View {
        VStack {
            YTextField(text: $email, placeholder: "test@gmail.com")
            YSecureField(text: $password, placeholder: "Parol")
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                SubmitButton(title: "Kirish") {
                    loginTapped()
                }
                SubmitButton(title: "Ro'yhatdan o'tish", backgroundColor: Color.green) {
                    showSignup = true
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .dismissKeyboardOnTap()
        .navigationBarBackButtonHidden()
        .padding()
        .navigationDestination(isPresented: $showSignup) {
            SignupView()
        }
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

    private func loginTapped() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Email va parol kiritilishi shart!"
            showAlert = true
            return
        }

        isLoading = true
        Auth.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(_):
                    email = ""
                    password = ""
                    showMainView = true
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                    email = ""
                    password = ""
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
