//
//  ExtensionUIColor.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 12..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(R: Int, G: Int, B: Int, alpha: Double) {
        self.init(red: CGFloat(R)/255, green: CGFloat(G)/255, blue: CGFloat(B)/255, alpha: CGFloat(alpha))
    }
}
