//
//  AnyLanguageBundle.swift
//  AmberShop
//
//  Created by Kirill on 01.12.2021.
//

import Foundation

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
                  
                  return super.localizedString(forKey: key, value: value, table: tableName)
              }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
            NotificationCenter.default.post(name: NSNotification.Name("LocalizationChanged"), object: nil)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
