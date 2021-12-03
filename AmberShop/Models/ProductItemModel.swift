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
    let characteristics: [Characteristic]
    
    var formatedPrice: String {
        String(format: "%.02f", Double(price) ?? 470.0)
    }
}

struct Characteristic: Codable {
    let attribute_group_id: String
    let name: String
    let attribute: [Attribute]
}

struct Attribute: Codable {
    let attribute_id: String
    let name: String
    let text: String
}

extension ProductItemModel: Equatable, Hashable {
    static func ==(lhs: ProductItemModel, rhs: ProductItemModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
