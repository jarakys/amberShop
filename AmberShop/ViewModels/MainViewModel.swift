//
//  MainViewModel.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation
import Combine

class MainViewModel: BaseViewModel {
    @Published private(set) var nodes: [CategoryModel] = []
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        inProgress = true
        StoreManager.shared.getCategories(completion: {[weak self] categories, error in
            guard let self = self else { return }
            self.inProgress = false
            guard let categories = categories else {
                self.error = error
                return
            }
            self.nodes = categories
        })
    }
    
    func handleCategoryClick(_ categoryId: String) {
        
    }

}
