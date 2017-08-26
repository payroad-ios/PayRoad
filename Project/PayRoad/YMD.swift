//
//  YMD.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 14..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

struct YMD {
    
    var year = 1970
    var month = 1
    var day = 1
    
    var date: Date {
        var dateComponents = DateComponents()
        dateComponents.year = self.year
        dateComponents.month = self.month
        dateComponents.day = self.day
        
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
    
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self.date)
    }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self.date)
    }
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    init(date: Date, timeZone: TimeZone = TimeZone.current) {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        self.init(year: year, month: month, day: day)
    }
    
    public func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self.date)
    }
    
    public mutating func add(day: Int) {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: day, to: self.date)!
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
    
    func compareRangeOfDate(date: Date) -> Bool {
        let calendar = Calendar.current
        let isDate = calendar.isDate(self.date, inSameDayAs: date)
        return isDate
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
