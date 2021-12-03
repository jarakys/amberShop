//
//  BasketItem.swift
//  AmberShop
//
//  Created by Kirill on 02.12.2021.
//

import Foundation

class BasketWrapItem: Codable {
    let id: String
    let product: ProductDetailModel
    let basketModel: BasketItem
    
    init(product: ProductDetailModel, basketModel: BasketItem) {
        id = UUID().description
        self.product = product
        self.basketModel = basketModel
    }
    
    var price: Double {
        (Double(basketModel.price) ?? 0) * Double(basketModel.quantity)
    }
    
    var formatedPrice: String {
        String(format: "%.02f", price)
    }
}

extension BasketWrapItem: Equatable, Hashable {
    static func == (lhs: BasketWrapItem, rhs: BasketWrapItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class BasketItem: Codable {
    let product_id: Int
    let name: String
    var quantity: Int
    let model: String
    let options: [OptionSelectionNodeState]
    let price: String
    
    init(product_id: Int, name: String, quantity: Int, model: String, options: [OptionSelectionNodeState], price: String) {
        self.product_id = product_id
        self.name = name
        self.quantity = quantity
        self.model = model
        self.options = options
        self.price = price
    }
}
