//
//  ProductSpecificationsTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

class ProductSpecificationsTableViewCell: UITableViewCell {
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var materialNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeNameLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var typeInflictionLabel: UILabel!
    @IBOutlet weak var typeInflictionNameLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var manufacturerNameLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var availabilityNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.hexColor(hex: "f7f7f7")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for model: ProductDetailModel, branchName: String) {
        materialLabel.localizationKey = "material"
        sizeLabel.localizationKey = "sizes"
        branchLabel.localizationKey = "branch"
        manufacturerLabel.localizationKey = "manufacturer"
        typeInflictionLabel.localizationKey = "type_printing"
        availabilityLabel.localizationKey = "availability"
        
        if let material = model.characteristics.first?.attribute.first(where: { $0.name == "material".localized }) {
            materialNameLabel.attributedText = material.text.getHTMLText(with: materialNameLabel.font)
        }
        
        if let sizes = model.option.first(where: { $0.name == "Размер" || $0.name == "Розмір" }) {
            sizeNameLabel.text = sizes.product_option_value.map({ $0.name }).joined(separator: ", ")
        }
        manufacturerNameLabel.attributedText = model.manufacturer?.getHTMLText(with: manufacturerNameLabel.font)
        typeInflictionNameLabel.localizationKey = "thermal_transfer"
        availabilityNameLabel.localizationKey = (Int(model.quantity) ?? 0) > 0 ? "in_stock" : "not_in_stock"
        branchNameLabel.text = branchName
    }
    
}
