//
//  CartTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productsTableView: ContentSizedTableView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    public var itemDeletedAction: (() -> Void)?
    
    private static var summeryPrefix: String {
        "total_payable".localized
    }
    
    var dataRows = [BasketWrapItem]() {
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
        
        dataRows = LocalStorageManager.shared.get(key: .savedProducts) ?? []
        calculateTotalPrice()
        productsTableView.sizeChanged = {[weak self] in
            self?.containerView.layer.remove(edge: .left)
            self?.containerView.layer.remove(edge: .top)
            self?.containerView.layer.remove(edge: .right)
            self?.containerView.layer.remove(edge: .bottom)
            
            //WTF?
            self?.containerView.layer.addBorder(edge: .left, color: .black.withAlphaComponent(0.3), thickness: 0.5)
            self?.containerView.addBorderTop(size: 0.5, color: .black.withAlphaComponent(0.3))
            self?.containerView.layer.addBorder(edge: .right, color: .black.withAlphaComponent(0.3), thickness: 0.5)
            self?.containerView.layer.addBorder(edge: .bottom, color: .black.withAlphaComponent(0.3), thickness: 0.5)
            self?.sizeChanged?()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LocalizationChanged"), object: nil, queue: .main, using: {[weak self] _ in
            self?.calculateTotalPrice()
        })
    }
    
    public func configure(for products: [BasketWrapItem]) {
        
//        dataRows = products
    }
    
    private func calculateTotalPrice() {
        let sum = dataRows.reduce(0, { result, nextItem in
            nextItem.price + result
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
            self.itemDeletedAction?()
        }
        
        cell.countChanged = {[weak self] in
            self?.calculateTotalPrice()
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
