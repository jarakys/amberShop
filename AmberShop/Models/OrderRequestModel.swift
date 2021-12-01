//
//  OrderRequestModel.swift
//  AmberShop
//
//  Created by Kirill on 30.11.2021.
//

import Foundation

struct ProductOption: Codable {
    let product_option_id: String
    let product_option_value_id: String
    let name: String
    let value: String
}

struct ProductModel: Codable {
    let product_id: Int
    let name: String
    let quantity: Int
    let model: String
    let options: [ProductOption]
}

struct OrderRequestModel: Codable {
    let shipping_value: Double
    let comment: String?
    let products: [ProductModel]
    let email: String
    let telephone: String
    let firstname: String
    let lastname: String
    let address: String
    let number: String
}
