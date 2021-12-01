//
//  String+isMatch.swift
//  AmberShop
//
//  Created by Kirill on 30.11.2021.
//

import Foundation

extension String {
    func isMatch(_ regex: String) -> Bool{
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
