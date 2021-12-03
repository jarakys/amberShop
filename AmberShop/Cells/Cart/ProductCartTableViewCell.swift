//
//  ProductCartTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class ProductCartTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var model: ProductDetailModel?
    private var basketItem: BasketItem?
    private var modelBasket: BasketWrapItem?
    
    public var countChanged: (() -> Void)?
    
    var count = 1
    public var deleteAction: (() -> Void) = {}
    
    @IBAction func decrementAcction(_ sender: Any) {
        guard count > 1 else { return }
        count = count - 1
        basketItem?.quantity -= 1
        countLabel.text = count.description
        countChanged?()
        calculateSum()
    }
    @IBAction func incrementAction(_ sender: Any) {
        guard count < Int(model?.quantity ?? "0") ?? 10 else { return }
        count = count + 1
        basketItem?.quantity += 1
        countLabel.text = count.description
        countChanged?()
        calculateSum()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.font = .boldSystemFont(ofSize: 16)
        
        iconImageVIew.layer.borderWidth = 0.5
        iconImageVIew.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        containerStackView.backgroundColor = UIColor.hexColor(hex: "F7F7F7")
        containerStackView.layer.cornerRadius = 10
        
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        deleteButton.addTarget(self, action: #selector(deleteButtonDidClick), for: .touchUpInside)
    }
    
    func configure(for model: BasketWrapItem) {
        self.model = model.product
        self.basketItem = model.basketModel
        self.modelBasket = model
        iconImageVIew.loadImage(imageURL: (model.product.add_photo1 ?? model.product.add_photo2?.first ?? model.product.add_photo2?.last ?? ""))
        titleLabel.attributedText = model.product.name.getHTMLText(with: titleLabel.font)
        count = model.basketModel.quantity
        countLabel.text = count.description
        calculateSum()
    }
    
    private func calculateSum() {
        guard let modelBasket = modelBasket else { return }
        
        priceLabel.text = modelBasket.formatedPrice
    }

    @objc func deleteButtonDidClick() {
        deleteAction()
    }
}
