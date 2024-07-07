//
//  SellProductModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 07/07/24.
//

import Foundation

struct Sale: Codable {
    let productId: String
    let buyer: String
    let description: String
    let amount: Double
    let instalmentCount: Int?
    let delayInDays: Int?
    let firstPayment: Double?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case buyer
        case description
        case amount
        case instalmentCount = "instalment_count"
        case delayInDays = "delay_in_days"
        case firstPayment = "first_payment"
        case phone
    }
}
