//
//  ContentSizedTableView.swift
//  AmberShop
//
//  Created by Kirill on 30.11.2021.
//

import UIKit

protocol ContentSizedTableViewDelegate {
    func sizeChanged()
}

final class ContentSizedTableView: UITableView {
    
    private var oldContentSize: CGFloat = 0
    
    public var sizeChanged: (() -> Void)?
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        if oldContentSize != contentSize.height {
            sizeChanged?()
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
