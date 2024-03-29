//
//  UIImageView+LoadImage.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(imageURL: String, completionHandler: (() -> Void)? = nil) {
        guard let url = URL(string:imageURL) else { return }
        kf.setImage(with: ImageResource(downloadURL: url, cacheKey: imageURL), completionHandler: { result in
            completionHandler?()
        })
    }
}
