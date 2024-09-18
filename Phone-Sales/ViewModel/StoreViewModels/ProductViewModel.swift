//
//  ProductsViewModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 30/06/24.
//

import Foundation



class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var selectedProduct: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var filter: ProductFilter?
    var searchQuery: String = ""
    
    func fetchProducts() {
        isLoading = true
        errorMessage = nil
        ProductService().getProducts(filter: filter, searchQuery: searchQuery) { [weak self] fetchedProducts in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.products = fetchedProducts ?? []
            }
        }
    }
    
    func applyFilter(filter: ProductFilter) {
        self.filter = filter
        fetchProducts()
    }
    
    func updateSearchQuery(_ query: String) {
        searchQuery = query
        fetchProducts()
    }
    
    func findProductById(_ id: String) {
        fetchProducts()
        if let product = products.first(where: { $0.id == id }) {
            self.selectedProduct = product
        } else {
            self.selectedProduct = nil
        }
    }
}


