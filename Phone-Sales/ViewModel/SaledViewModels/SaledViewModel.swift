//
//  SaledViewModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 14/07/24.
//

import Foundation

class SaledViewModel: ObservableObject {
        @Published var products: [Sale] = []
       // @Published var selectedProduct: Product?
        @Published var isLoading = false
        @Published var errorMessage: String?
        
        var filter: ProductFilter?
        var searchQuery: String = ""
        
        private let productService = GetSaledProducts()
        
        func fetchProducts() {
            isLoading = true
            errorMessage = nil
            productService.getProducts(filter: filter, searchQuery: searchQuery) { [weak self] fetchedProducts in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let fetchedProducts = fetchedProducts {
                        self?.products = fetchedProducts.sales
                    } else {
                        self?.errorMessage = "Failed to load products"
                    }
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
        
//        func findProductById(_ id: String) {
//            if let product = products.first(where: { $0.id == id }) {
//                self.selectedProduct = product.product.first
//            } else {
//                self.selectedProduct = nil
//            }
//        }
}
