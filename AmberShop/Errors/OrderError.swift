//
//  OrderError.swift
//  AmberShop
//
//  Created by Kirill on 30.11.2021.
//

import Foundation

enum OrderError: Error, CaseIterable {
    case name
    case secondName
    case phone
    case email
    case cityAddress
    case postalAddress
    case agreement
}
