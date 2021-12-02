//
//  UIButton+Localization.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

extension UIButton {
    static var localizedKey:UInt8 = 0

    public var localizationKey: String? {
        set {
            self.setTitle(newValue?.localized, for: .normal)
            objc_setAssociatedObject(self, &UIButton.localizedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &UIButton.localizedKey) as? String
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LocalizationChanged"), object: nil, queue: .main, using: {[weak self] _ in
            self?.setTitle(self?.localizationKey?.localized ?? self?.titleLabel?.text, for: .normal)
        })
    }
}
