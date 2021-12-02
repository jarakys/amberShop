//
//  String+HTMLText.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import UIKit

extension String {
    public func getHTMLText(with font: UIFont?) -> NSAttributedString? {
//        guard let htmlData = data(using: .unicode) else { return nil }
//        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        return try? NSAttributedString(HTMLString: self, font: font)
    }
}
