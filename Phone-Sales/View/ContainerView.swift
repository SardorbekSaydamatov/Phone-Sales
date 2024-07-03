//
//  ConstentView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import SwiftUI

struct ContainerView: View {
    @State private var showMenu = false
    @State private var selectedTab = 0
    @State private var showAddProduct: Bool = false
    
    @State var navigationTitle: Array = ["Ombor", "Savdo tarixi", "Kirim chiqim", "Profil"]
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab)  {
                StoreView()
                    .tag(0)
                SalesView()
                    .tag(1)
                IncomeOutcomeView()
                    .tag(2)
                ProfileView()
                    .tag(3)
            }
            .ignoresSafeArea()
            
            
            SideMenuView(selectedTab: $selectedTab, isShowing: $showMenu)
        }
        .navigationBarBackButtonHidden()
        .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
        .navigationTitle(navigationTitle[selectedTab])
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    showMenu.toggle()
                }, label: {
                    Image(systemName: "line.3.horizontal")
                })
                .foregroundStyle(.primary)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if selectedTab == 0 {
                    Button(action: {
                        showAddProduct = true
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .foregroundStyle(.primary)
                } else {
                    
                }
            }
        }
        .navigationDestination(isPresented: $showAddProduct) {
            ProductAddView()
        }
    }
}

#Preview {
    NavigationStack {
        ContainerView()
    }
}
