//
//  BaseViewModel.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation
import Combine

class BaseViewModel {
    @Published public var error: Error?
    @Published public var inProgress: Bool = false
}
