//
//  UIButton+Localization.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

extension UIButton {
    static var localizedKey: UInt8 = 0
    static var imageLocalizedKey: UInt8 = 0
    
    public var imageLocalizationKey: String? {
        set {
            if let newValue = newValue {
                setImage(UIImage(named: newValue.localized), for: .normal)
                setImage(UIImage(named: newValue.localized), for: .highlighted)
                setImage(UIImage(named: newValue.localized), for: .selected)
                isEnabled = false
                backgroundColor = .clear
                frame = CGRect(x: 0, y: 0, width: 80, height: 40)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
            }
            objc_setAssociatedObject(self, &UIButton.localizedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &UIButton.localizedKey) as? String
        }
    }

    public var localizationKey: String? {
        set {
            self.setTitle(newValue?.localized, for: .normal)
            objc_setAssociatedObject(self, &UIButton.localizedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &UIButton.localizedKey) as? String
        }
    }
    
    convenience init(imageLocalizationKey: String) {
        self.init()
        self.imageLocalizationKey = imageLocalizationKey
        registerForNotification()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        registerForNotification()
    }
    
    private func registerForNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LocalizationChanged"), object: nil, queue: .main, using: {[weak self] _ in
            self?.setTitle(self?.localizationKey?.localized ?? self?.titleLabel?.text, for: .normal)
        })
    }
}
