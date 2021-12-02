//
//  MenuViewModel.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation
import Combine

class MenuViewModel: BaseViewModel {
    @Published private(set) var nodes: [MenuModel] = []
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        inProgress = true
        StoreManager.shared.getMenu(completion: {[weak self] menuItems, error in
            guard let self = self else { return }
            guard let menuItems = menuItems else {
                self.error = error
                return
            }
            var nodes = menuItems.map({ MenuModel(name: $0.name, menuItems: $0.subcategories) })
            nodes.append(MenuModel(name: "about_us".localized, menuItems: []))
            nodes.append(MenuModel(name: "delivery".localized, menuItems: []))
            nodes.append(MenuModel(name: "contacts".localized, menuItems: []))
            self.nodes = nodes
            self.inProgress = false
        })
    }
    
}
