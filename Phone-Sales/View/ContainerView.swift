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
                Group  {
                    switch selectedTab {
                    case 0:
                        StoreView()
                    case 1:
                        SalesView()
                    case 2:
                        IncomeOutcomeView()
                    case 3:
                        ProfileView()
                    default:
                        EmptyView()
                    }
                }
            
                SideMenuView(selectedTab: $selectedTab, isShowing: $showMenu)
                }
                .navigationBarBackButtonHidden()
                .navigationTitle(showMenu ? "" : navigationTitle[selectedTab])
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        if !showMenu {
                            Button(action: {
                                showMenu.toggle()
                            }, label: {
                                Image(systemName: "line.3.horizontal")
                            })
                            .foregroundStyle(.primary)
                        }
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
