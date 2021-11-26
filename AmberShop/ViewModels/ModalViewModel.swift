//
//  ModalViewModel.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation
import Combine

class ModalViewModel: BaseViewModel {
    let title: String
    let image: String?
    let name: String
    
    init(product: ProductItemModel) {
        title = "Футболка добавлена в корзину"
        image = product.add_photo1
        name = product.name
    }
}
