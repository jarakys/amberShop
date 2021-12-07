//
//  PaymentViewModel.swift
//  AmberShop
//
//  Created by Kirill on 07.12.2021.
//

import Foundation
import Cloudipsp

class PaymentViewModel {
    let customerEmail: String
    let sum: Double
    
    init(customerEmail: String, sum: Double) {
        self.customerEmail = customerEmail
        self.sum = sum
    }    
}
