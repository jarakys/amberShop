//
//  MenuItemModel.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation

struct MenuItemModel: Codable {
    let category_id: String
    let name: String
    let image: String?
    let subcategories: [SubcategoryModel]
}

struct SubcategoryModel: Codable {
    let subcategory_id: String
    let name: String
}
