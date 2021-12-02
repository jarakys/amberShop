//
//  TextFieldWithPadding.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 03.12.2021.
//

import UIKit

class TextFieldWithPadding: UITextField {
    
    @IBInspectable var topPadding: CGFloat = 10
    @IBInspectable var bottomPadding: CGFloat = 10
    @IBInspectable var leftPadding: CGFloat = 20
    @IBInspectable var rightPadding: CGFloat = 20
    
    var textPadding: UIEdgeInsets {
        UIEdgeInsets(
                top: topPadding,
                left: leftPadding,
                bottom: bottomPadding,
                right: rightPadding
            )

    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
    
}
