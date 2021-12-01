//
//  TableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

class ProductSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var firstViewLabel: UILabel!
    @IBOutlet weak var secondViewLabel: UILabel!
    @IBOutlet weak var thirdViewLabel: UILabel!
    @IBOutlet weak var firstViewButton: UIButton!
    @IBOutlet weak var secondViewButton: UIButton!
    @IBOutlet weak var thirdViewButton: UIButton!
    @IBOutlet weak var toCartButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
