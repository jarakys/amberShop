//
//  ContactInformationTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 22.11.2021.
//

import UIKit

class ContactInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var adressTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addBorderTop(size: 0.5, color: .gray)
        self.addBorderBottom(size: 0.5, color: .gray)
        adressTextView.localizationKey = "shop_adress"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
