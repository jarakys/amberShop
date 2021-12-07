//
//  ProductDetailModel.swift
//  AmberShop
//
//  Created by Kirill on 02.12.2021.
//

import Foundation

struct ProductOptionValueModel: Codable {
    let product_option_value_id: String
    let option_value_id: String
    let name: String
    let image: String?
    let price: Bool
    let price_prefix: String
    let qcolor: String
    
}

struct ProductOptionModel: Codable {
    let product_option_id: String
    let product_option_value: [ProductOptionValueModel]
    let option_id: String
    let name: String
    let type: String
    let value: String
    let required: String
}

struct ProductDetailModel: Codable {
    let id: String
    let name: String
    let manufacturer: String?
    let category_id: String
    let description: String
    
    let model: String
    let price: String
    let special: String?
    let add_photo1: String?
    let add_photo2: [String]?
    let quantity: String
    let characteristics: [Characteristic]
    let option: [ProductOptionModel]
    let table: String?
    
    var formatedPrice: String {
        String(format: "%.02f", Double(price) ?? 470.0)
    }
}
