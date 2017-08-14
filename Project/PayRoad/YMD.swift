//
//  YMD.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 14..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

struct YMD {
    
    var year = 0
    var month = 0
    var day = 0
    
    var date: Date {
        var dateComponents = DateComponents()
        dateComponents.year = self.year
        dateComponents.month = self.month
        dateComponents.day = self.day
        
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self.date)
    }
    
    public func string() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self.date)
    }
    
    public mutating func add(day: Int) {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: day, to: self.date)!
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
}

// MARK: Protocol

extension YMD: Hashable, Equatable, Comparable {
    
    var hashValue: Int {
        return (year * 10000 + month * 100 + day).hashValue
    }
    
    static func == (lhs: YMD, rhs: YMD) -> Bool {
        return (lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day)
    }
    
    static func < (lhs: YMD, rhs: YMD) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
}
