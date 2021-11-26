//
//  AboutUsTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 26.11.2021.
//

import UIKit

class DeliveryInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imgContainerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .boldSystemFont(ofSize: 17)
        self.backgroundColor = UIColor.hexColor(hex: "F7F7F7")
        contentTextView.backgroundColor = UIColor.hexColor(hex: "F7F7F7")
        imgContainerStackView.spacing = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImages(imgs: [UIImage]?)
    {
        if imgs != nil {
            for item in imgs! {
                let imgView = UIImageView(image: item)
                imgContainerStackView.addArrangedSubview(imgView)
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
        }
    }
    
    func setImage(img: UIImage) {
        let imgView = UIImageView(image: img)
        imgContainerStackView.addArrangedSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setTextView(text: String) {
        contentTextView.text = text
    }
    
}
