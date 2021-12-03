//
//  ProductDetailViewModel.swift
//  AmberShop
//
//  Created by Kirill on 02.12.2021.
//

import Foundation
import Combine

class ProductDetailViewModel: BaseViewModel {
    
    private let productId: String
    
    public let branchName: String
    @Published public var productItemDetails: ProductDetailModel?
    
    init(productId: String, branchName: String) {
        self.productId = productId
        self.branchName = branchName
        super.init()
        loadData()
    }
    
    func loadData() {
        self.inProgress = true
        NetworkManager.shared.sendRequest(route: .productDetails(productId: productId), completion: {[weak self] result in
            self?.inProgress = false
            switch result {
            case .success(let data):
                do {
                    self?.productItemDetails = try JSONDecoder().decode(ProductDetailModel.self, from: data)
                } catch(let error) {
                    self?.productItemDetails = nil
                    self?.error = error
                }
            case .failure(let error):
                self?.productItemDetails = nil
                self?.error = error
            }
        })
    }
    
    
}
