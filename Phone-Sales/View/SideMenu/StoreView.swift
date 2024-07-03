//
//  StoreView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//
import SwiftUI

struct StoreView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchQuery = ""
    @State private var showProductsCartView = false
    @State private var showFilter = false
    @State private var selectedProduct: Product?
    @State private var selectedFilters = ProductFilter()

    var body: some View {
        TabView {
            VStack(spacing: 0) {
                headerView
                
                productListView
                Spacer()
            }
            .onAppear {
                viewModel.fetchProducts()
            }
            .sheet(isPresented: $showFilter, content: {
                filterButtons
                    .padding(.top)
                    .foregroundStyle(.primary)
                    .presentationDetents([.height(200)])
            })
            .navigationDestination(isPresented: $showProductsCartView) {
                if let product = selectedProduct {
                    ProductDetailView(images: product.images, title: product.name, imei: product.imei, cost: product.cost, price: product.price, isNew: product.isNew, haveDocument: product.haveDocument, extraInfo: product.extraInfo, infoAboutOwner: product.infoAboutOwner)
                        .onDisappear {
                            selectedProduct = nil
                        }
                }
            }
            .tabItem {
                Label("Products", systemImage: "list.dash")
            }
            
            Text("Second Tab")
                .tabItem {
                    Label("Second", systemImage: "square.and.pencil")
                }
        }
    }
    
    private var filterButtons: some View {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    selectedFilters.isNew = nil
                    selectedFilters.haveDocument = nil
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Barchasi")
                })
                
                Button(action: {
                    if selectedFilters.isNew == nil {
                        selectedFilters.isNew = []
                    }
                    selectedFilters.isNew?.append(true)
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Faqat yangilari")
                })
                
                Button(action: {
                    if selectedFilters.isNew == nil {
                        selectedFilters.isNew = []
                    }
                    selectedFilters.isNew?.append(false)
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Faqat eskilari")
                })
                
                Button(action: {
                    if selectedFilters.haveDocument == nil {
                        selectedFilters.haveDocument = []
                    }
                    selectedFilters.haveDocument?.append(true)
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Dokument bor")
                })
                
                Button(action: {
                    if selectedFilters.haveDocument == nil {
                        selectedFilters.haveDocument = []
                    }
                    selectedFilters.haveDocument?.append(false)
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Dokument yo'q")
                })
            }
        }

    
    private var headerView: some View {
        HStack {
            TextField("Search", text: $searchQuery)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onChange(of: searchQuery) { newValue, oldValuex in
                    viewModel.updateSearchQuery(newValue)
                }
            
            Button(action: {
                showFilter.toggle()
            }, label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .resizable()
                    .foregroundColor(.primary)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
            })
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    
    private var productListView: some View {
    
        List {
            ForEach(viewModel.products) { product in
                HStack {
                    AsyncImage(url: URL(string: product.images[0])) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80)
                            .foregroundStyle(Color.init(.secondarySystemBackground))
                            .clipShape(Circle())
                            .padding(.vertical, 25)
                        
                    }
        
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.headline)
                        Text("Imei: \(product.imei)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(product.extraInfo)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(formatDate(product.createdAt))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    selectedProduct = product
                    showProductsCartView.toggle()
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }

}

#Preview {
    NavigationStack {
        StoreView()
    }
}
