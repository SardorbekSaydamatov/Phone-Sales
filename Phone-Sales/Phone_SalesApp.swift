//
//  Phone_SalesApp.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 26/06/24.
//

import SwiftUI
import FirebaseCore


@main
struct Phone_SalesApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if UserDefaults.standard.string(forKey: "authToken") != nil {
                    ContainerView()
                } else {
                    LoginView()
                }
            }
        }
    }
}
