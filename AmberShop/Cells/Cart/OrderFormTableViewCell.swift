//
//  OrderFormTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 26.11.2021.
//

import UIKit

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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
