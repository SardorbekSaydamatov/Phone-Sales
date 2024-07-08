//
//  AddProductModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 08/07/24.
//

import Foundation

struct AddProductModel: Codable {
    let cost: Double
    let extra_info: String
    let have_document: Bool
    let images: [String]
    let name: String
    let imei: String
    let info_about_owner: String
    let is_new: Bool
    let price: Double
}
