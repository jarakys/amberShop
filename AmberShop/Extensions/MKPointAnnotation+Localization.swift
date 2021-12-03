//
//  MKPointAnnotation+Localization.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import Foundation
import MapKit
// MKPointAnnotation

extension MKPointAnnotation {
    static var localizedKey:UInt8 = 0

    public var localizationKey: String? {
        set {
            self.title = newValue?.localized
            objc_setAssociatedObject(self, &MKPointAnnotation.localizedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &MKPointAnnotation.localizedKey) as? String
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LocalizationChanged"), object: nil, queue: .main, using: {[weak self] _ in
            self?.title = self?.localizationKey?.localized ?? self?.title
        })
    }
}
