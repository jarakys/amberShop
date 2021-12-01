//
//  modalViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 23.11.2021.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toCartButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    public var productItem: ProductItemModel!
    
    private lazy var viewModel: ModalViewModel = {
        ModalViewModel(product: productItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toCartButton.layer.cornerRadius = 10
        toCartButton.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        toCartButton.tintColor = .white
        
        iconImageView.layer.borderWidth = 0.5
        iconImageView.layer.borderColor = UIColor.gray.cgColor
        
        titleLabel.text = viewModel.title
        iconImageView.loadImage(imageURL: viewModel.image ?? "")
        descriptionLabel.attributedText = viewModel.name.getHTMLText()
        
        closeButton.addTarget(self, action: #selector(closeButtonDidClick), for: .touchUpInside)
        toCartButton.localizationKey = "go_to_basket"
        titleLabel.text = "t_shirt_added_to_cart".localized
    }
    
    @objc func closeButtonDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
}
