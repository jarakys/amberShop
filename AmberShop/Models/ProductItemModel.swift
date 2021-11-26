//
//  GoodsItemModel.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation

struct ProductItemModel: Codable {
    let id: String
    let name: String
    let category_id: String
    let description: String
    let price: String
    let special: String?
    let add_photo1: String?
    let add_photo2: [String?]?
    let characteristics: [String?]?
}
