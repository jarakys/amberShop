//
//  UITextView +Localization.swift
//  AmberShop
//
//  Created by Kirill on 03.12.2021.
//

import Foundation
import UIKit

extension UITextField {
    static var localizedKey:UInt8 = 0
    static var localizedPlaceholderKey:UInt8 = 0

    public var localizationKey: String? {
        set {
            text = newValue?.localized
            objc_setAssociatedObject(self, &UITextField.localizedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &UITextField.localizedKey) as? String
        }
    }
    
    public var localizationKeyAttributedPlaceholderKey: String? {
        set {
            placeholder = newValue?.localized
            objc_setAssociatedObject(self, &UITextField.localizedPlaceholderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &UITextField.localizedPlaceholderKey) as? String
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LocalizationChanged"), object: nil, queue: .main, using: {[weak self] _ in
            self?.text = self?.localizationKey?.localized ?? self?.text
            self?.placeholder = self?.localizationKeyAttributedPlaceholderKey ?? self?.placeholder
        })
    }
}
