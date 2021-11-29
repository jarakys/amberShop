//
//  ProductCartTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class ProductCartTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.font = .boldSystemFont(ofSize: 16)
        
        iconImageVIew.layer.borderWidth = 0.5
        iconImageVIew.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override var intrinsicContentSize: CGSize {
        return contentView.frame.size
    }
}
