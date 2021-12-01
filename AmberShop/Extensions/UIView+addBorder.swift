//
//  UIView+addBorder.swift
//  AmberShop
//
//  Created by Kirill on 30.11.2021.
//

import UIKit

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()
        border.name = edge.rawValue.description
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }
    
    func remove(edge: UIRectEdge) {
        guard let sublayers = sublayers else { return }
        sublayers.filter({ $0.name == edge.rawValue.description }).forEach({ $0.removeFromSuperlayer() })
    }
    
    func addGreyBottomBorder(){
        let color = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
        self.addBorder(edge: UIRectEdge.bottom, color: color, thickness: 0.5)
    }
}
