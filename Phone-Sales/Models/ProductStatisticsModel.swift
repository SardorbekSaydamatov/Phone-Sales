//
//  ProductStatisticsModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 07/07/24.
//

import SwiftUI
import Foundation

struct ProductStatistics: Identifiable, Codable {
    let id = UUID()
    let totalProducts: Int
    let averageCost: Double
    let averagePrice: Double
    let totalCost: Int
    let totalPrice: Int
    let newProductsCount: Int
    let oldProductsCount: Int
    let documentCount: Int
    let noDocumentCount: Int
    let productsWithPriceCount: Int
    let productsWithoutPriceCount: Int
    let distinctExtraInfo: [String]
    let imagesCount: Int
    let organizationId: String
    let totalExtraInfoTypes: Int
    
    enum CodingKeys: String, CodingKey {
        case totalProducts = "total_products"
        case averageCost = "average_cost"
        case averagePrice = "average_price"
        case totalCost = "total_cost"
        case totalPrice = "total_price"
        case newProductsCount = "new_products_count"
        case oldProductsCount = "old_products_count"
        case documentCount = "document_count"
        case noDocumentCount = "no_document_count"
        case productsWithPriceCount = "products_with_price_count"
        case productsWithoutPriceCount = "products_without_price_count"
        case distinctExtraInfo = "distinct_extra_info"
        case imagesCount = "images_count"
        case organizationId = "organization_id"
        case totalExtraInfoTypes = "total_extra_info_types"
    }
}

struct ProductStatisticsResponse: Codable {
    let success: Bool
    let data: [ProductStatistics]
}

