//
//  UIView+addBlurLoader.swift
//  AmberShop
//
//  Created by Kirill on 02.12.2021.
//

import UIKit

extension UIView {
    func showBlurLoader() {
        let blurLoader = BlurLoader(frame: frame)
        self.addSubview(blurLoader)
        blurLoader.isUserInteractionEnabled = true
        blurLoader.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        blurLoader.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        blurLoader.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor).isActive = true
        blurLoader.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor).isActive = true
        blurLoader.translatesAutoresizingMaskIntoConstraints = false
    }

    func removeBluerLoader() {
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.isUserInteractionEnabled = false
            blurLoader.removeFromSuperview()
        }
    }
}
