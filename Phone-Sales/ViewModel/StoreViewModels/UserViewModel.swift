//
//  UserViewModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 05/07/24.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var role: String? = nil

    init() {
        loadUserRole()
    }

    func loadUserRole() {
        if let userData = UserDefaults.standard.dictionary(forKey: "userData"),
           let role = userData["role"] as? String {
            self.role = role
        }
    }
}

