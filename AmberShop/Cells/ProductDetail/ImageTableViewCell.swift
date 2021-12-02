//
//  ImageTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.masksToBounds = false
        iconImageView.layer.cornerRadius = 8
        iconImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        iconImageView.layer.shadowOpacity = 1
        iconImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        iconImageView.layer.shadowRadius = 16
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
