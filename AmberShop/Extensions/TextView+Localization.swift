//
//  TextView+Localization.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import Foundation
import UIKit

extension UITextView {
    static var localizedKey:UInt8 = 0

    public var localizationKey: String? {
        set {
            text = newValue?.localized
            objc_setAssociatedObject(self, &UILabel.localizedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &UILabel.localizedKey) as? String
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LocalizationChanged"), object: nil, queue: .main, using: {[weak self] _ in
            self?.text = self?.localizationKey?.localized ?? self?.text
        })
    }
}
