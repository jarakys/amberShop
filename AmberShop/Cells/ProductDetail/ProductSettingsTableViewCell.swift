//
//  TableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit
import DropDown

class ProductSettingsModel {
    var color = OptionSelectionNodeState()
    var size = OptionSelectionNodeState()
    var count = OptionSelectionNodeState()
    
    var isValid: Bool {
        color.isValid && size.isValid
    }
}

class OptionSelectionNodeState: Codable {
    var product_option_id: String?
    var product_option_value_id: String?
    var name: String?
    var value: String?
    
    var isValid: Bool {
        [product_option_id, product_option_value_id, name, value].compactMap({ $0 }).count == 4
    }
}

struct DropDownDataSource {
    let id: String
    let nodes: [DropDownNodes]
}

struct DropDownNodes {
    let name: String
    let id: String
}

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
    
    public var toBasketClick: ((ProductSettingsModel) ->Void)?
    public var errorOccurred: (() -> Void)?
    
    private var state = ProductSettingsModel()
    
    let colorDropDown = DropDown()
    let sizeDropDown = DropDown()
    let numberDropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showColors(_:))))
        secondView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSizes(_:))))
        thirdView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showQuantity(_:))))
    }
    
    func configure(for model: ProductDetailModel) {
        
        self.contentView.backgroundColor = UIColor.hexColor(hex: "f7f7f7")
        firstView.layer.cornerRadius = 8
        secondView.layer.cornerRadius = 8
        thirdView.layer.cornerRadius = 8
        
        toCartButton.localizationKey = "add_to_basket"
        toCartButton.layer.cornerRadius = 8
        toCartButton.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        toCartButton.tintColor = .white
        if let sizeModel = model.option.first(where: { $0.name == "Размер" || $0.name == "Розмір"}) {
            state.size.product_option_id = sizeModel.product_option_id
            state.size.name = sizeModel.name
            state.size.value = sizeModel.value
            let sizeDataSource = DropDownDataSource(id: sizeModel.product_option_id, nodes: sizeModel.product_option_value.map({ DropDownNodes(name: $0.name, id: $0.product_option_value_id)}))
            setupSizeDropDown(dataSource: sizeDataSource)
        }
        if let colorModel = model.option.first(where: { $0.name == "Цвет текста" || $0.name == "Колір тексту" }) {
            state.color.product_option_id = colorModel.product_option_id
            state.color.name = colorModel.name
            state.color.value = colorModel.value
            let colorDataSource = DropDownDataSource(id: colorModel.product_option_id, nodes: colorModel.product_option_value.map({ DropDownNodes(name: $0.name, id: $0.product_option_value_id)}))
            
            setupColorDropDown(dataSource: colorDataSource)
        }
        
        
        
        firstViewLabel.localizationKey = !state.color.isValid ? "text_color" : firstViewLabel.text
        secondViewLabel.localizationKey = !state.size.isValid ? "size" : secondViewLabel.text
        thirdViewLabel.localizationKey = !state.count.isValid ? "count" : thirdViewLabel.text
        
        guard let quantity = Int(model.quantity) else { return }
        setupNumberDropDown(dataSource: (1...quantity).map({ DropDownNodes(name: $0.description, id: $0.description) }))
    }
    
    func setOldPrice(text: String) {
        
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attrStr.length))
        oldPriceLabel.attributedText = attrStr
    }
    
    func setSalePrice(text: String) {
//        priceLabel.textColor = .red
        priceLabel.text = text
    }
    
    func setPrice(text: String) {
        priceLabel.text = text
    }
    
    @objc func showColors() {
        colorDropDown.show()
    }
    
    @IBAction func showColors(_ sender: Any) {
        showColors()
    }
    
    @IBAction func showSizes(_ sender: Any) {
        showSize()
    }
    @IBAction func showQuantity(_ sender: Any) {
        showNumber()
    }
    
    @objc func showSize() {
        sizeDropDown.show()
    }
    
    @objc func showNumber() {
        numberDropDown.show()
    }
    
    @IBAction func toCardDidClick(_ sender: Any) {
        guard state.isValid else {
            errorOccurred?()
            return
        }
        toBasketClick?(state)
    }
    
    func setupColorDropDown(dataSource: DropDownDataSource) {
        colorDropDown.anchorView = firstView
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        colorDropDown.dataSource = dataSource.nodes.map({ $0.name })
        colorDropDown.selectionAction = { [weak self] (index, item) in
            self?.state.color.product_option_value_id = dataSource.nodes[index].id
            self?.state.color.value = dataSource.nodes[index].name
            self?.firstViewLabel.text = item
        }
    }
    
    func setupSizeDropDown(dataSource: DropDownDataSource) {
        sizeDropDown.anchorView = secondView
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        sizeDropDown.dataSource = dataSource.nodes.map({ $0.name })
        sizeDropDown.selectionAction = { [weak self] (index, item) in
            self?.state.size.product_option_value_id = dataSource.nodes[index].id
            self?.state.size.value = dataSource.nodes[index].name
            self?.secondViewLabel.text = item
        }
    }
    
    func setupNumberDropDown(dataSource: [DropDownNodes]) {
        numberDropDown.anchorView = thirdView
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        numberDropDown.dataSource = dataSource.map({ $0.name })
        numberDropDown.selectionAction = { [weak self] (index, item) in
            self?.state.count.value = dataSource[index].id
            self?.thirdViewLabel.text = item
        }
    }
}
