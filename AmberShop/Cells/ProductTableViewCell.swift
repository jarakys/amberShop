//
//  ProductTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 23.11.2021.
//

import UIKit
import Presentr

protocol ProductTableViewCellDelegate {
    func toCartButtonDidClick(model: ProductItemModel)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var toCartButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var delegate: ProductTableViewCellDelegate?
    
    private var productItem: ProductItemModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toCartButton.layer.cornerRadius = 8
        toCartButton.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        toCartButton.tintColor = .white
        toCartButton.addTarget(self, action: #selector(toCartButtonDidClick), for: .touchUpInside)
        
        descriptionLabel.textColor = .gray
        
        
        priceLabel.font = .boldSystemFont(ofSize: 20)
        
        containerView.backgroundColor = .white
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        
        titleLabel.textContainer.maximumNumberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 17)
        descriptionLabel.textContainer.maximumNumberOfLines = 1
        
        toCartButton.setTitle("to_basket".localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for model: ProductItemModel) {
        productItem = model
        titleLabel.attributedText = model.name.getHTMLText()
        descriptionLabel.attributedText = model.description.getHTMLText()
        priceLabel.text = model.price
        iconImageView.loadImage(imageURL: model.add_photo1 ?? "")
    }
    
    @objc func toCartButtonDidClick(_ sender: Any) {
        guard let model = productItem else { return }
        delegate?.toCartButtonDidClick(model: model)
    }
    
}
