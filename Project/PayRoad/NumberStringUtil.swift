//
//  NumberStringUtil.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 22..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

struct NumberStringUtil {
    static func string(number: Float, dropPoint: Int) -> String {
        return String(format: "%.\(dropPoint)f", number)
    }
    
    static func string(number: Double, dropPoint: Int) -> String {
        return String(format: "%.\(dropPoint)f", number)
    }
}
