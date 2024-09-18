//
//  StoreView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//
import SwiftUI

struct StoreView: View {
    
    var body: some View {
        TabView {
            MahsulotlarView()
                .tabItem {
                    Label("Mahsulotlar", systemImage: "list.dash")
                }
            
            HisobotView()
                .tabItem {
                    Label("Hisobot", systemImage: "square.and.pencil")
                }
        }
    }
}

#Preview {
    NavigationStack {
        StoreView()
    }
}
