//
//  ExtensionUIView.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 16..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UIView {
    func addUnderline(color: UIColor, borderWidth: Double) {
        let underlineView = UIView(frame: CGRect(x: 0, y: (frame.height) - CGFloat(borderWidth), width: frame.width, height: CGFloat(borderWidth)))
        underlineView.backgroundColor = color
        addSubview(underlineView)
    }
    
    func addUpperline(color: UIColor, borderWidth: Double) {
        let upperlineView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat(borderWidth)))
        upperlineView.backgroundColor = color
        addSubview(upperlineView)
    }
    
    func cornerRound(cornerOptions: UIRectCorner, cornerRadius: Int) {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: cornerOptions,
                                    cornerRadii:CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
