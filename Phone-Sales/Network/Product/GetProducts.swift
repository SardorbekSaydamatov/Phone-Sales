//
//  GetProducts.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 28/06/24.
//

import Foundation

class ProductService {
    var savedToken: String = ""
    
    func getProducts(filter: ProductFilter?, searchQuery: String = "", completion: @escaping ([Product]?) -> Void) {
        var urlComponents = URLComponents(string: "https://server-of-phone-sale-pos.vercel.app/api/product/search")!
        
        var queryItems = [URLQueryItem(name: "text", value: searchQuery)]
        
        if let filter = filter {
            if let isNewList = filter.isNew {
                for isNew in isNewList {
                    queryItems.append(URLQueryItem(name: "is_new", value: isNew ? "new" : "not_new"))
                }
            }
            if let documentAvailableList = filter.haveDocument {
                for documentAvailable in documentAvailableList {
                    queryItems.append(URLQueryItem(name: "have_document", value: documentAvailable ? "have" : "not_have"))
                }
            }
        }
        
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            completion(nil)
            return
        }
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            savedToken = token
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("bimus2022", forHTTPHeaderField: "x-api-key")
        request.addValue("Token \(savedToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ProductListResponse.self, from: data)
                completion(response.data)
            } catch {
                print("Error decoding products: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

struct ProductListResponse: Codable {
    let success: Bool
    let data: [Product]
}


