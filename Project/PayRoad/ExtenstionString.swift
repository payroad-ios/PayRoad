//
//  ExtenstionString.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 18..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

enum NumberStringOption {
    case `default`
    case seperator
}

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
    
    func thousandsSeparate() -> String {
        if self.contains("."),
            let double = Double(self) {
            return self.thousandsSeparator(double: double)
        } else {
            if let int = Int(self) {
                return self.thousandsSeparator(integer: int)
            }
        }
        
        print("string is not number")
        return self
    }
    
    func thousandsSeparator(integer: Int) -> String {
        let isMinus = integer < 0 ? true : false
        let convertNumber = abs(integer)
        var resultString: String = ""
        var index = 0
        let string = String(convertNumber).characters
        let stringCount = string.count
        
        for i in string.reversed() {
            index += 1
            resultString += String(i)
            if index % 3 == 0 && index != stringCount {
                resultString += ","
            }
        }
        var result = isMinus ? "-" : ""
        result.append(String(resultString.characters.reversed()))
        return result
    }
    
    func thousandsSeparator(double: Double) -> String {
        let string = String(double).components(separatedBy: ".")
        let stringSeparate = thousandsSeparator(integer: Int(string.first!)!)
        return stringSeparate + "." + string.last!
    }
}
