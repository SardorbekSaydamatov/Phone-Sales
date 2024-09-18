//
//  Savdolar.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 11/07/24.
//

import SwiftUI

struct Savdolar: View {
    @StateObject var viewModel = SaledViewModel()
    @State private var searchQuery = ""
    @State private var showFilter = false
    @State private var selectedFilters = ProductFilter()
    
    var body: some View {
        VStack(spacing: 0) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                headerView
                if  viewModel.isLoading {
                    ProgressView()
                        .padding(.top)
                }
                saledListView
                Spacer()
            }
        }
        .sheet(isPresented: $showFilter, content: {
            filterButtons
                .foregroundStyle(.primary)
                .presentationDetents([.height(200)])
        })
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
    
    private var saledListView: some View {
        List(viewModel.products) { product in
            HStack {
                ForEach(product.product) { product in
                    if !product.images.isEmpty {
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
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 80, height: 80)
                            Text(product.name.prefix(3).uppercased())
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.buyer)
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(2)
                    Text(product.description)
                        .font(.system(size: 16, weight: .medium))
                        .lineLimit(2)
                    Text(product.product.first?.name ?? "Nomi yoq")
                        .font(.subheadline)
                }
                
                Spacer()
                if product.unpaidAmount != 0 {
                    if let firstUnreadInstallment = product.installments.first(where: { !$0.read }) {
                        let formattedDate = formatDateString(firstUnreadInstallment.date)
                        let installmentDate = parseDateString(firstUnreadInstallment.date) ?? Date()
                        let currentDate = Date()
                        
                        Text(formattedDate)
                            .foregroundColor(installmentDate < currentDate ? .red : .primary)
                        
                    } else {
                        Text("To'langan")
                    }
                } else {
                    Text("To'langan")
                }
            }
        }
        .onAppear(perform: {
            viewModel.fetchProducts()
        })
        .scrollIndicators(.hidden)
        .listStyle(PlainListStyle())
    }
    
    private var filterButtons: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Button(action: {
                selectedFilters.status = nil
                viewModel.applyFilter(filter: selectedFilters)
            }, label: {
                Text("Barchasi")
            })
            
            Button(action: {
                if selectedFilters.status == nil {
                    selectedFilters.status = []
                }
                selectedFilters.status?.append("paid")
                viewModel.applyFilter(filter: selectedFilters)
            }, label: {
                Text("To'langanlar")
            })
            
            Button(action: {
                if selectedFilters.status == nil {
                    selectedFilters.status = []
                }
                selectedFilters.status?.append("unpaid")
                viewModel.applyFilter(filter: selectedFilters)
            }, label: {
                Text("Qarzdorlar")
            })
            
            Button(action: {
                if selectedFilters.status == nil {
                    selectedFilters.status = []
                }
                selectedFilters.status?.append("late")
                viewModel.applyFilter(filter: selectedFilters)
            }, label: {
                Text("Kechikanlar")
            })
        }
        .padding(.horizontal, 40)
    }
    
    func formatDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = inputFormatter.date(from: dateString) else {
            return "Invalid date"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        return outputFormatter.string(from: date)
    }
    
    func parseDateString(_ dateString: String) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return inputFormatter.date(from: dateString)
    }
}

#Preview {
    Savdolar()
}
