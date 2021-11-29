//
//  AutoSizingUITableView.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 29.11.2021.
//

import UIKit

class AutoSizingUITableView: UITableView {

//    override var contentSize:CGSize {
//        didSet {
//            invalidateIntrinsicContentSize()
//            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: contentSize.height)
//        }
//    }
//
//    override var intrinsicContentSize: CGSize {
////        layoutIfNeeded()
////        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//
//        return contentSize
//    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
      }
      
      override var intrinsicContentSize: CGSize {
        let height = contentSize.height
        return CGSize(width: contentSize.width, height: height)
      }
}
