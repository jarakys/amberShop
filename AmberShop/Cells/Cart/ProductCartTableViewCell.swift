//
//  ProductCartTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class ProductCartTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var count = 1
    public var deleteAction: (() -> Void) = {}
    
    @IBAction func decrementAcction(_ sender: Any) {
        count = count - 1
        countLabel.text = count.description
    }
    @IBAction func incrementAction(_ sender: Any) {
        count = count + 1
        countLabel.text = count.description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.font = .boldSystemFont(ofSize: 16)
        
        iconImageVIew.layer.borderWidth = 0.5
        iconImageVIew.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        containerStackView.backgroundColor = UIColor.hexColor(hex: "F7F7F7")
        containerStackView.layer.cornerRadius = 10
        
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        deleteButton.addTarget(self, action: #selector(deleteButtonDidClick), for: .touchUpInside)
    }
    
    func configure(for model: ProductItemModel) {
        iconImageVIew.loadImage(imageURL: (model.add_photo1 ?? model.add_photo2?.first ?? model.add_photo2?.last ?? "") ?? "")
        titleLabel.attributedText = model.name.getHTMLText()
        priceLabel.text = model.price
    }

    @objc func deleteButtonDidClick() {
        deleteAction()
    }
}
