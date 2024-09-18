//
//  GetSaledStatistics.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 07/08/24.
//

import Foundation

class GetSaledStatistics {
    var savedToken: String = ""
    
    func getStatistics(completion: @escaping ([Datum]?) -> Void) {
        guard let url = URL(string: "https://server-of-phone-sale-pos.vercel.app/api/sale/overview") else {
            print("Invalid URL")
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
            if let error = error {
                print("Error fetching statistics: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")

            }
            
            do {
                let response = try JSONDecoder().decode(SaledStatisticsResponse.self, from: data)
                completion(response.data)
            } catch {
                print("Error decoding statistics: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}




