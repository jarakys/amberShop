//
//  LabelCollectionViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 22.11.2021.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor =  isSelected ? .white : .black
            backgroundColor = isSelected ? UIColor.hexColor(hex: "223766") : .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 16
    }

    func setTitle(text: String) {
        self.titleLabel.text = text
    }
}
