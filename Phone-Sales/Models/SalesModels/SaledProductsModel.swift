//
//  SaledProductsModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 14/07/24.
//

import Foundation

struct Welcome: Codable {
    let success: Bool
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let sales: [Sale]
}

// MARK: - Sale
struct Sale: Codable, Identifiable {
    let id, organizationID, productID, buyer: String
    let description: String
    let amount: Int
    let createdAt, updatedAt: String
    let installments: [Installment]
    let product: [Product]
    let unpaidAmount: Int
    let isLate: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case organizationID = "organization_id"
        case productID = "product_id"
        case buyer, description, amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case installments, product, unpaidAmount
        case isLate = "is_late"
    }
}

// MARK: - Installment
struct Installment: Codable, Identifiable {
    let id, date, saleID: String
    let totalAmount: Int
    let message: String
    let payments: [Payment]
    let queue: Int
    let read: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date
        case saleID = "sale_id"
        case totalAmount = "total_amount"
        case message, payments, queue, read
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Payment
struct Payment: Codable {
    let amount: Int
    let message, createdAt, updatedAt, id: String

    enum CodingKeys: String, CodingKey {
        case amount, message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id = "_id"
    }
}

