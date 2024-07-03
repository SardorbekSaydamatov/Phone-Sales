//
//  ProductsViewModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 30/06/24.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    var filter: ProductFilter?
    var searchQuery: String = ""
    
    func fetchProducts() {
        ProductService().getProducts(filter: filter, searchQuery: searchQuery) { [weak self] fetchedProducts in
            DispatchQueue.main.async {
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
}

