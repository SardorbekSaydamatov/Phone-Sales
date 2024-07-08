//
//  AddProductService.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 08/07/24.
//

import Foundation


class AddProductService {
    var savedToken: String = ""

        func addProduct(product: AddProductModel, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "https://server-of-phone-sale-pos.vercel.app/api/product") else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                savedToken = token
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("bimus2022", forHTTPHeaderField: "x-api-key")
            request.addValue("Token \(savedToken)", forHTTPHeaderField: "Authorization")
            
            do {
                let jsonData = try JSONEncoder().encode(product)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }.resume()
        }
}
