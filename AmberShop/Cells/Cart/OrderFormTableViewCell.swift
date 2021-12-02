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
    @IBOutlet weak var policyLabel: UILabel!
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
    
    var errors = OrderError.allCases
    
    public var checkoutOrderClick: ((OrderError?, UserDataModel?) -> Void)?
    
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
        checkoutButton.addTarget(self, action: #selector(checkoutButtonDidClick), for: .touchUpInside)
        
        checkButton.backgroundColor = lightGrayColor
        checkButton.layer.cornerRadius = 5
        checkButton.tintColor = .black
        checkButton.addTarget(self, action: #selector(checkButtonDidClick), for: .touchUpInside)
        

        nameTextField.backgroundColor = lightGrayColor
        nameTextField.layer.cornerRadius = 10
        nameTextField.attributedPlaceholder = NSAttributedString(string: "your_name".localized, attributes: attribute)
        
        surmaneTextField.backgroundColor = lightGrayColor
        surmaneTextField.layer.cornerRadius = 10
        surmaneTextField.attributedPlaceholder = NSAttributedString(string: "your_lastname".localized, attributes: attribute)
        
        phoneNumberTextField.backgroundColor = lightGrayColor
        phoneNumberTextField.layer.cornerRadius = 10
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "phone_number".localized, attributes: attribute)
        
        emailTextField.backgroundColor = lightGrayColor
        emailTextField.layer.cornerRadius = 10
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: attribute)
        
        cityTextField.backgroundColor = lightGrayColor
        cityTextField.layer.cornerRadius = 10
        cityTextField.attributedPlaceholder = NSAttributedString(string: "your_city".localized, attributes: attribute)
        
        postAdressTexField.backgroundColor = lightGrayColor
        postAdressTexField.layer.cornerRadius = 10
        postAdressTexField.attributedPlaceholder = NSAttributedString(string: "post_office".localized, attributes: attribute)
        
        commentsTextField.backgroundColor = lightGrayColor
        commentsTextField.layer.cornerRadius = 10
        commentsTextField.attributedPlaceholder = NSAttributedString(string: "comment_on_the_order".localized, attributes: attribute)

        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        policyLabel.text = "policy".localized
        checkoutButton.setTitle("checkout".localized, for: .normal)
        
        setupTextFields()
    }
    
    func setupTextFields() {
        [nameTextField, surmaneTextField, phoneNumberTextField, emailTextField, cityTextField, postAdressTexField, commentsTextField].forEach{ field in
            field.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if nameTextField.text?.isEmpty == false {
            nameTextField.layer.remove(edge: .bottom)
            errors.removeAll(where: { $0 == .name })
        } else {
            errors.append(.name)
        }
        if surmaneTextField.text?.isEmpty == false {
            surmaneTextField.layer.remove(edge: .bottom)
            errors.removeAll(where: { $0 == .secondName })
        } else {
            errors.append(.secondName)
        }
        if phoneNumberTextField.text?.isEmpty == false {
            phoneNumberTextField.layer.remove(edge: .bottom)
            errors.removeAll(where: { $0 == .phone })
        } else {
            errors.append(.phone)
        }
        if emailTextField.text?.isEmpty == false && emailTextField.text?.isMatch("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") == true {
            emailTextField.layer.remove(edge: .bottom)
            errors.removeAll(where: { $0 == .email })
        } else {
            errors.append(.email)
        }
        if cityTextField.text?.isEmpty == false {
            cityTextField.layer.remove(edge: .bottom)
            errors.removeAll(where: { $0 == .cityAddress })
        } else {
            errors.append(.cityAddress)
        }
        if postAdressTexField.text?.isEmpty == false {
            postAdressTexField.layer.remove(edge: .bottom)
            errors.removeAll(where: { $0 == .postalAddress })
        } else {
            errors.append(.postalAddress)
        }
    }
    
    @objc func checkoutButtonDidClick(_ sender: AnyObject) {
        var name: String? = nil
        var secondName: String? = nil
        var phone: String? = nil
        var email: String? = nil
        var cityAddress: String? = nil
        var postalAddress: String? = nil
        if errors.contains(.name) {
            nameTextField.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
        } else {
            name = nameTextField.text
        }
        if errors.contains(.secondName) {
            surmaneTextField.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
        } else {
            secondName = surmaneTextField.text
        }
        if errors.contains(.phone) {
            phoneNumberTextField.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
        } else {
            phone = phoneNumberTextField.text
        }
        if errors.contains(.email) {
            emailTextField.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
        } else {
            email = emailTextField.text
        }
        if errors.contains(.cityAddress) {
            cityTextField.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
        } else {
            cityAddress = cityTextField.text
        }
        if errors.contains(.postalAddress) {
            postAdressTexField.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
        } else {
            postalAddress = postAdressTexField.text
        }
        var userDataModel: UserDataModel?
        if [name, secondName, phone, email, cityAddress, postalAddress].compactMap({ $0 }).count == 6 {
            userDataModel = UserDataModel(comment: commentsTextField.text, email: email!, telephone: phone!, firstname: name!, lastname: secondName!, address: cityAddress!, number: postalAddress!)
        }
        checkoutOrderClick?(errors.first, userDataModel)
    }
    
    @objc func checkButtonDidClick() {
        isChecked.toggle()
    }
}
