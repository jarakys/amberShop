//
//  ProductTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 23.11.2021.
//

import UIKit
import Presentr

protocol ProductTableViewCellDelegate: AnyObject {
    func toCartButtonDidClick(model: ProductItemModel)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var toCartButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: ProductTableViewCellDelegate?
    
    private var productItem: ProductItemModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toCartButton.layer.cornerRadius = 8
        toCartButton.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        toCartButton.tintColor = .white
        
        
        priceLabel.font = .boldSystemFont(ofSize: 20)
        
        containerView.backgroundColor = .white
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        
        titleLabel.textContainer.maximumNumberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 17)
        
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        self.selectedBackgroundView = selectedBackgroundView
        
        toCartButton.localizationKey = "to_basket"
        
//        toCartButton.setTitle("to_basket".localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for model: ProductItemModel) {
        productItem = model
        titleLabel.attributedText = model.name.getHTMLText(with: titleLabel.font)
        priceLabel.text = model.formatedPrice
        iconImageView.loadImage(imageURL: model.add_photo1 ?? "")
        toCartButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    }
    
    @objc func toCartButtonDidClick(_ sender: Any) {
        guard let model = productItem else { return }
        delegate?.toCartButtonDidClick(model: model)
    }
    
}
