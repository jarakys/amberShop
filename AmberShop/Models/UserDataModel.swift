//
//  UserDataModel.swift
//  AmberShop
//
//  Created by Kirill on 30.11.2021.
//

import Foundation

class UserDataModel: Codable {
    let shipping_value: Double = 0
    let comment: String?
    let email: String
    let telephone: String
    let firstname: String
    let lastname: String
    let address: String
    let number: String
    
    var products: [BasketItem] = []
    
    init(email: String, telephone: String, firstname: String, lastname: String, address: String, number: String, comment: String? = "") {
        self.email = email
        self.telephone = telephone
        self.firstname = firstname
        self.lastname = lastname
        self.address = address
        self.number = number
        self.comment = comment
    }
}
