
import SwiftUI

struct MahsulotlarView: View {
    
    @StateObject private var viewModel = ProductViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @State private var searchQuery = ""
    @State private var showProductsCartView = false
    @State private var showFilter = false
    @State private var selectedProduct: Product?
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
                    productListView
                    Spacer()
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .dismissKeyboardOnTap()
        .sheet(isPresented: $showFilter, content: {
            filterButtons
                .padding(.top)
                .foregroundStyle(.primary)
                .presentationDetents([.height(200)])
        })
        .navigationDestination(isPresented: $showProductsCartView) {
            if let product = selectedProduct {
                ProductDetailView(viewModel: viewModel, id: product.id, showCost: userViewModel.role == "admin" ? true : false)
            }
        }
    }
    
    private var filterButtons: some View {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    selectedFilters.is_new = nil
                    selectedFilters.have_document = nil
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Barchasi")
                })
                
                Button(action: {
                    if selectedFilters.is_new == nil {
                        selectedFilters.is_new = []
                    }
                    selectedFilters.is_new?.append(true)
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Faqat yangilari")
                })
                
                Button(action: {
                    if selectedFilters.is_new == nil {
                        selectedFilters.is_new = []
                    }
                    selectedFilters.is_new?.append(false)
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Faqat eskilari")
                })
                
                Button(action: {
                    if selectedFilters.have_document == nil {
                        selectedFilters.have_document = []
                    }
                    selectedFilters.have_document?.append(true)
                    viewModel.applyFilter(filter: selectedFilters)
                }, label: {
                    Text("Dokument bor")
                })
                
                Button(action: {
                    if selectedFilters.have_document == nil {
                        selectedFilters.have_document = []
                    }
                    selectedFilters.have_document?.append(false)
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
        
        List(viewModel.products) { product in
            HStack {
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
        .onAppear {
            viewModel.fetchProducts()
            userViewModel.loadUserRole()
        }
        .scrollIndicators(.hidden)
        .listStyle(PlainListStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    MahsulotlarView()
}
