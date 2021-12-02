//
//  TableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit
import DropDown

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
    
    let colorDropDown = DropDown()
    let sizeDropDown = DropDown()
    let numberDropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupColorDropDown()
        setupSizeDropDown()
        setupNumberDropDown()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        firstViewButton.addTarget(self, action: #selector(showColors), for: .touchUpInside)
        secondViewButton.addTarget(self, action: #selector(showSize), for: .touchUpInside)
        thirdViewButton.addTarget(self, action: #selector(showNumber), for: .touchUpInside)
        
        self.contentView.backgroundColor = UIColor.hexColor(hex: "f7f7f7")
        firstView.layer.cornerRadius = 8
        secondView.layer.cornerRadius = 8
        thirdView.layer.cornerRadius = 8
        
        toCartButton.localizationKey = "add_to_basket"
        toCartButton.layer.cornerRadius = 8
        toCartButton.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        toCartButton.tintColor = .white
    }
    
    func setOldPrice(text: String) {
        
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attrStr.length))
        oldPriceLabel.attributedText = attrStr
    }
    
    func setSalePrice(text: String) {
        priceLabel.textColor = .red
        priceLabel.text = text
    }
    
    func setPrice(text: String) {
        priceLabel.text = text
    }
    
    
    @objc func showColors() {
        colorDropDown.show()
    }
    
    @objc func showSize() {
        sizeDropDown.show()
    }
    
    @objc func showNumber() {
        numberDropDown.show()
    }
    
    func setupColorDropDown() {
        colorDropDown.anchorView = firstView
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        colorDropDown.dataSource = [
            "Синий",
            "Ред",
            "Оранж",
            "Пюрпл",
            "Перламутровый"
        ]
        colorDropDown.selectionAction = { [weak self] (index, item) in
            self?.firstViewLabel.text = item
        }
    }
    
    func setupSizeDropDown() {
        sizeDropDown.anchorView = secondView
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        sizeDropDown.dataSource = [
            "long",
            "very long",
            "so very long",
            "extreme long",
            "very extreme, incredible long"
        ]
        sizeDropDown.selectionAction = { [weak self] (index, item) in
            self?.secondViewLabel.text = item
        }
    }
    
    func setupNumberDropDown() {
        numberDropDown.anchorView = thirdView
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        numberDropDown.dataSource = [
            "1",
            "2",
            "3",
            "4",
            "10000000000000"
        ]
        numberDropDown.selectionAction = { [weak self] (index, item) in
            self?.thirdViewLabel.text = item
        }
    }
    
}
