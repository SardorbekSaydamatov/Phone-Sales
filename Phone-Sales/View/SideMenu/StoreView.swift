//
//  StoreView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//
import SwiftUI

struct StoreView: View {
    @StateObject private var viewModel = ProductViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @State private var searchQuery = ""
    @State private var showProductsCartView = false
    @State private var showFilter = false
    @State private var selectedProduct: Product?
    @State private var selectedFilters = ProductFilter()
    
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
