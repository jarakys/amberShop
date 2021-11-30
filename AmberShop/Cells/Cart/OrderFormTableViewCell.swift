//
//  OrderFormTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 26.11.2021.
//

import UIKit
import IQKeyboardManagerSwift

class OrderFormTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surmaneTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postAdressTexField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let lightGrayColor = UIColor.hexColor(hex: "F7F7F7")
    let attribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
    var isChecked = false {
        didSet {
            if isChecked {
                checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            } else {
                checkButton.setImage(nil, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enableDebugging = false
    }
    
    private func configure() {
        checkoutButton.tintColor = .white
        checkoutButton.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        checkoutButton.layer.cornerRadius = 10
        
        checkButton.backgroundColor = lightGrayColor
        checkButton.layer.cornerRadius = 5
        checkButton.tintColor = .black
        checkButton.addTarget(self, action: #selector(checkButtonDidClick), for: .touchUpInside)
        

        nameTextField.backgroundColor = lightGrayColor
        nameTextField.layer.cornerRadius = 10
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Ваше имя", attributes: attribute)
        nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        surmaneTextField.backgroundColor = lightGrayColor
        surmaneTextField.layer.cornerRadius = 10
        surmaneTextField.attributedPlaceholder = NSAttributedString(string: "Ваша фамилия", attributes: attribute)
        surmaneTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        phoneNumberTextField.backgroundColor = lightGrayColor
        phoneNumberTextField.layer.cornerRadius = 10
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes: attribute)
        phoneNumberTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        emailTextField.backgroundColor = lightGrayColor
        emailTextField.layer.cornerRadius = 10
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: attribute)
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        cityTextField.backgroundColor = lightGrayColor
        cityTextField.layer.cornerRadius = 10
        cityTextField.attributedPlaceholder = NSAttributedString(string: "Ваш населенный пункт", attributes: attribute)
        cityTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        postAdressTexField.backgroundColor = lightGrayColor
        postAdressTexField.layer.cornerRadius = 10
        postAdressTexField.attributedPlaceholder = NSAttributedString(string: "Отделение почты или адресс", attributes: attribute)
        postAdressTexField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        commentsTextField.backgroundColor = lightGrayColor
        commentsTextField.layer.cornerRadius = 10
        commentsTextField.attributedPlaceholder = NSAttributedString(string: "Комментарий к заказу", attributes: attribute)
        commentsTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, -30, 0)

        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
    }
    
    
    @objc func checkButtonDidClick() {
        isChecked.toggle()
    }
}
