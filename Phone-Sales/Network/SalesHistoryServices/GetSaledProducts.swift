//
//  GetSaledProducts.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 11/07/24.
//

import Foundation

class GetSaledProducts: ObservableObject {
    var savedToken: String = ""
    
    func getProducts(filter: ProductFilter?, searchQuery: String = "", completion: @escaping (DataClass?) -> Void) {
        var urlComponents = URLComponents(string: "https://server-of-phone-sale-pos.vercel.app/api/sale/search")!
        
        var queryItems = [URLQueryItem(name: "text", value: searchQuery)]
        
        if let filter = filter {
            if let statusList = filter.status {
                for status in statusList {
                    queryItems.append(URLQueryItem(name: "status", value: status))
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
                let response = try JSONDecoder().decode(Welcome.self, from: data)
                completion(response.data)
            } catch {
                print("Error decoding products: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
