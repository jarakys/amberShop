//
//  CartTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productsTableView: ContentSizedTableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private static let summeryPrefix = "total_payable".localized
    
    var dataRows = [ProductItemModel]() {
        didSet {
            self.productsTableView.reloadData()
        }
    }
    
    public var sizeChanged: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.separatorStyle = .none
        productsTableView.allowsSelection = false
        productsTableView.register(UINib(nibName: "ProductCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCartTableViewCell")
        
        totalPriceLabel.font = .boldSystemFont(ofSize: 18)
        
        dataRows = LocalStorageManager.shared.get(key: .savedProducts) ?? []
        calculateTotalPrice()
        productsTableView.sizeChanged = {[weak self] in
            self?.containerView.addBorderLeft(size: 0.5, color: .black.withAlphaComponent(0.3))
            self?.containerView.addBorderRight(size: 0.5, color: .black.withAlphaComponent(0.3))
            self?.containerView.addBorderBottom(size: 0.5, color: .black.withAlphaComponent(0.3))
            self?.containerView.addBorderTop(size: 0.5, color: .black.withAlphaComponent(0.3))
            self?.sizeChanged?()
        }
    }
    
    public func configure(for products: [ProductItemModel]) {
        
//        dataRows = products
    }
    
    private func calculateTotalPrice() {
        let sum = dataRows.reduce(0, { result, nextItem in
            (Double(nextItem.price) ?? 0) + result
        })
        totalPriceLabel.text = "\(Self.summeryPrefix) \(sum)"
    }
}

extension CartTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCartTableViewCell", for: indexPath) as! ProductCartTableViewCell
        cell.configure(for: dataRows[indexPath.row])
        cell.deleteAction = { [weak self] in
            guard let self = self else { return }
            LocalStorageManager.shared.remove(key: .savedProducts, value: self.dataRows[indexPath.row])
            self.dataRows.remove(at: indexPath.row)
            self.calculateTotalPrice()
            self.productsTableView.reloadData()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.invalidateIntrinsicContentSize()
        cell.layoutIfNeeded()
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
