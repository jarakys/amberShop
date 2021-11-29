//
//  CartTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productsTableView: AutoSizingUITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var dataRows = ["test","test1","test2"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.separatorStyle = .none
        productsTableView.allowsSelection = false
        productsTableView.register(UINib(nibName: "ProductCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCartTableViewCell")
        
        totalPriceLabel.font = .boldSystemFont(ofSize: 18)
        totalPriceLabel.text = "Итого к оплате"
        
        containerView.addBorderLeft(size: 0.5, color: .black.withAlphaComponent(0.3))
        containerView.addBorderRight(size: 0.5, color: .black.withAlphaComponent(0.3))
        containerView.addBorderBottom(size: 0.5, color: .black.withAlphaComponent(0.3))
        containerView.addBorderTop(size: 0.5, color: .black.withAlphaComponent(0.3))
        
    }
    

//    override var intrinsicContentSize: CGSize {
////        return CGSize(width: productsTableView.frame.width, height: productsTableView.frame.height)
//        CGSize(width: UIScreen.main.bounds.width, height: 600)
//    }
}

extension CartTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCartTableViewCell", for: indexPath) as! ProductCartTableViewCell
        cell.iconImageVIew.image = UIImage(named: "testImg")
        cell.titleLabel.text = dataRows[indexPath.row]
        cell.deleteAction = { [weak self] in
            guard let self = self else {return}
            self.dataRows.remove(at: indexPath.row)
            self.productsTableView.reloadData()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
