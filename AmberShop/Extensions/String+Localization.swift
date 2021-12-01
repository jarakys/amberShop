//
//  String+Localization.swift
//  AmberShop
//
//  Created by Kirill on 01.12.2021.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
