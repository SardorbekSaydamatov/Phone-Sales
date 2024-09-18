//
//  SalesHistoryView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 11/07/24.
//

import SwiftUI

struct SalesHistoryView: View {
    var body: some View {
        TabView {
            Savdolar()
                .tabItem {
                    Label("Savdolar", systemImage: "list.dash")
                }
            Hisobot()
                .tabItem {
                    Label("Hisobot", systemImage: "square.and.pencil")
                }
        }
    }
}

#Preview {
    SalesHistoryView()
}
