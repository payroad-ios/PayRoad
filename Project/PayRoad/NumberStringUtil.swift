//
//  NumberStringUtil.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 22..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

struct NumberStringUtil {
    static func numberString(number: Float, dropPoint: Int) -> String {
        return String(format: "%.\(dropPoint)f", number)
    }
    
    static func numberString(number: Double, dropPoint: Int) -> String {
        return String(format: "%.\(dropPoint)f", number)
    }
    
    static func roughString(number: Float) -> String {
        return numberString(number: number, dropPoint: 2)
    }
    
    static func roughString(number: Double) -> String {
        return numberString(number: number, dropPoint: 2)
    }
}
