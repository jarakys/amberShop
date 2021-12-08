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
    @IBOutlet var topTextViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomTextViewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.hexColor(hex: "F7F7F7")
        contentTextView.backgroundColor = UIColor.hexColor(hex: "F7F7F7")
        imgContainerStackView.spacing = 8
        contentTextView.sizeToFit()
        contentTextView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imgContainerStackView.arrangedSubviews.forEach({view in
            view.removeFromSuperview()
        })
        contentTextView.isHidden = true
        topTextViewConstraint.constant = 0
        bottomTextViewConstraint.constant = 0
    }
    
    func setImages(imgs: [UIImage]?)
    {
        if imgs != nil {
            for item in imgs! {
                let imgView = UIImageView(image: item)
                imgView.contentMode = .scaleAspectFit
                imgContainerStackView.addArrangedSubview(imgView)
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
        }
    }
    
    func setLeftTopConstraint(constatnt: CGFloat) {
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constatnt).isActive = true
    }
    
    func setImage(img: UIImage) {
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgContainerStackView.addArrangedSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
    }
    
    func setTitle(text: String) {
        titleLabel.localizationKey = text
    }
    
    func setText(text: String) {
        contentTextView.isHidden = false
        topTextViewConstraint.constant = 16
        bottomTextViewConstraint.constant = 16
        contentTextView.localizationKey = text
    }
}
