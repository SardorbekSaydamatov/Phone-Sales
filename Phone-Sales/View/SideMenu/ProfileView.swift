//
//  ProfileView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var showLogin: Bool = false
    var body: some View {
        VStack {
            Text("Profile!")
            
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "userData")
                showLogin = true
            }, label: {
                Text("Sign out")
            })
        }
        .navigationDestination(isPresented: $showLogin) {
            LoginView()
        }
    }
}

#Preview {
    ProfileView()
}
