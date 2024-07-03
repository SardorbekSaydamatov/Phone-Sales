//
//  Auth.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import Foundation

class Auth {
    
    static let shared = Auth()
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "https://server-of-phone-sale-pos.vercel.app/api/auth/login") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("bimus2022", forHTTPHeaderField: "x-api-key")
        
        let parameters: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    
                    if let success = jsonResponse["success"] as? Bool, success {
                        if let token = jsonResponse["token"] as? String {
                            UserDefaults.standard.set(token, forKey: "authToken")
                            UserDefaults.standard.synchronize()
                            
                            print("Token received: \(token)")
                            
                            completion(.success(jsonResponse))
                        } else {
                            print("Token not found in response")
                            completion(.failure(NSError(domain: "NoToken", code: 0, userInfo: nil)))
                        }
                    } else {
                        let errorMessage = jsonResponse["error"] as? String ?? "Unknown error"
                        let error = NSError(domain: "InvalidCredentials", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                } else {
                    print("Failed to parse JSON")
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                }
            } catch let parsingError {
                print("Parsing error: \(parsingError.localizedDescription)")
                completion(.failure(parsingError))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Sign up
    
    
    func signUp(email: String, name: String, organizationName: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "https://server-of-phone-sale-pos.vercel.app/api/auth/signup") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("bimus2022", forHTTPHeaderField: "x-api-key")
        
        let parameters: [String: Any] = [
            "email": email,
            "name": name,
            "organization_name": organizationName,
            "password": password,
            "role": "admin"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        } catch {
            print("Error serializing parameters: \(error)")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    
                    if let success = jsonResponse["success"] as? Bool, success {
                        if let token = jsonResponse["token"] as? String {
                            UserDefaults.standard.set(token, forKey: "authToken")
                            UserDefaults.standard.synchronize()
                            
                            print("Token received: \(token)")
                            
                            completion(.success(jsonResponse))
                        } else {
                            print("Token not found in response")
                            completion(.failure(NSError(domain: "NoToken", code: 0, userInfo: nil)))
                        }
                    } else {
                        let errorMessage = jsonResponse["error"] as? String ?? "Unknown error"
                        let error = NSError(domain: "InvalidCredentials", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                } else {
                    print("Failed to parse JSON")
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                }
            } catch let parsingError {
                print("Parsing error: \(parsingError.localizedDescription)")
                completion(.failure(parsingError))
            }
        }
        task.resume()
    }
}
