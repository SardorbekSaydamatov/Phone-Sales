//
//  ProductsModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 30/06/24.
//

import Foundation

struct Product: Codable, Identifiable {
    var id: String
    var name: String
    var cost: Int
    var imei: String
    var price: Int
    var haveDocument: Bool
    var isNew: Bool
    var extraInfo: String
    var organizationId: String
    var images: [String]
    var saled: Bool
    var createdAt: Date
    var updatedAt: Date
    var infoAboutOwner: String
    
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
            case cost
            case imei
            case price
            case haveDocument = "have_document"
            case isNew = "is_new"
            case extraInfo = "extra_info"
            case organizationId = "organization_id"
            case images
            case saled
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case infoAboutOwner = "info_about_owner"
        }
    
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            cost = try container.decode(Int.self, forKey: .cost)
            imei = try container.decode(String.self, forKey: .imei)
            price = try container.decode(Int.self, forKey: .price)
            haveDocument = try container.decode(Bool.self, forKey: .haveDocument)
            isNew = try container.decode(Bool.self, forKey: .isNew)
            extraInfo = try container.decode(String.self, forKey: .extraInfo)
            organizationId = try container.decode(String.self, forKey: .organizationId)
            images = try container.decode([String].self, forKey: .images)
            saled = try container.decode(Bool.self, forKey: .saled)
            infoAboutOwner = try container.decode(String.self, forKey: .infoAboutOwner)
    
            // Date formatting
            let createdAtString = try container.decode(String.self, forKey: .createdAt)
            let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
    
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust as per your date format
    
            if let createdAtDate = dateFormatter.date(from: createdAtString) {
                createdAt = createdAtDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
    
            if let updatedAtDate = dateFormatter.date(from: updatedAtString) {
                updatedAt = updatedAtDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .updatedAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
        }
}
