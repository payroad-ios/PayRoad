//
//  ExtensionFloat.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 23..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

extension Float {
    func findZeroOnDecimal(maxDecimalPlace: Int) -> Int {
        var count = 0
        
        while Int(self * pow(10.0, Float(count + 1))) % 10 != 0 {
            count = count + 1
            
            if count >= maxDecimalPlace { break }
        }
        
        return count
    }
    
    func nonZeroString(maxDecimalPlace: Int, option: NumberStringOption) -> String {
        let result = NumberStringUtil.string(number: self, dropPoint: self.findZeroOnDecimal(maxDecimalPlace: maxDecimalPlace))
        
        switch option {
        case .default:
            return result
        case .seperator:
            return result.thousandsSeparate()
        }
    }
}
