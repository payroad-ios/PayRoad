//
//  ExtenstionString.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 18..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    func thousandsSeparator(integer: Int) -> String {
        var result: String = ""
        var index = 0
        let string = String(integer).characters
        let stringCount = string.count
        
        for i in string.reversed() {
            index += 1
            result += String(i)
            if index % 3 == 0 && index != stringCount {
                result += ","
            }
        }
        return String(result.characters.reversed())
    }
    
    func thousandsSeparator(double: Double) -> String {
        let string = String(double).components(separatedBy: ".")
        let stringSeparate = thousandsSeparator(integer: Int(string.first!)!)
        return stringSeparate + "." + string.last!
    }
}
