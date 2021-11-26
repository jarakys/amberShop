//
//  ProductViewModel.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation
import Combine

class ProductViewModel: BaseViewModel {
    @Published private(set) var nodes = [ProductItemModel]()
    
    private let categoryId: String
    
    init(categoryId: String) {
        self.categoryId = categoryId
        super.init()
        loadData()
    }
    
    func loadData() {
        inProgress = true
        NetworkManager.shared.sendRequest(route: .product(categoryId: categoryId), completion: {[weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    self.nodes = try JSONDecoder().decode([ProductItemModel].self, from: data)
                } catch(let error) {
                    self.error = error
                }
            case .failure(let error):
                self.error = error
            }
            self.inProgress = false
        })
    }
}
