//
//  BRCalendarFormatter.swift
//  PayRoad_CalendarPractice
//
//  Created by Febrix on 2017. 8. 12..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

enum DateType {
    case month
    case day
}

class BRCalendarFormatter {
    var calendar = Calendar.current

    let locale = Locale.current
    let timeZone = TimeZone.current

    func startOfMonth(for date: Date) -> Date {
        var extractDateComponents = calendar.dateComponents(in: timeZone, from: date)
        
        var dateComponents = DateComponents()
        dateComponents.year = extractDateComponents.year
        dateComponents.month = extractDateComponents.month
        return calendar.date(from: dateComponents)!
    }
    
    func date(byAdding: Calendar.Component, value: Int, to: Date) -> Date {
        return calendar.date(byAdding: byAdding, value: value, to: to)!
    }
    
    func string(for date: Date, type: DateType, locale: Locale? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy / MM"
        dateFormatter.locale = locale
        
        switch type {
        case .month:
            return dateFormatter.string(from: date)
        case .day:
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: date)
        }
    }
    
    func startOfDay(for date: Date) -> Date {
        return calendar.startOfDay(for: date)
    }
    
    func compareRangeOfDate(compareType: DateType, base: Date, compare: Date) -> Bool {
        let extractDateComponents = calendar.dateComponents(in: timeZone, from: base)
        
        var baseDateComponents = DateComponents()
        
        switch compareType {
        case .month:
            baseDateComponents.year = extractDateComponents.year
            baseDateComponents.month = extractDateComponents.month
        case .day:
            baseDateComponents.year = extractDateComponents.year
            baseDateComponents.month = extractDateComponents.month
            baseDateComponents.day = extractDateComponents.day
        }
        
        return calendar.date(compare, matchesComponents: baseDateComponents)
    }
    
    func compositionDayOfMonth(month: Date) -> [Date] {
        var dayOfMonthDateArray = [Date]()
        let extractDateComponents = calendar.dateComponents(in: timeZone, from: month)
        
        var dateComponents = DateComponents()
        dateComponents.year = extractDateComponents.year
        dateComponents.month = extractDateComponents.month
        
        let firstDayWeekday = calendar.dateComponents([.weekday], from: month).weekday!
        let dayOfMonthCount = calendar.dateComponents([.day], from: month, to: date(byAdding: .month, value: 1, to: month)).day!
        
        var compareDate = month
        
        //Previous Month
        for i in (1..<firstDayWeekday).reversed() {
            dayOfMonthDateArray.append(date(byAdding: .day, value: -i, to: month))
        }
        
        //Current Month
        for i in 0..<dayOfMonthCount {
            let addtingDate = date(byAdding: .day, value: i, to: month)
            dayOfMonthDateArray.append(addtingDate)
            compareDate = addtingDate
        }
        
        //Remain Next Month
        let remainCount = 7 - (dayOfMonthDateArray.count % 7 == 0 ? 7 : dayOfMonthDateArray.count % 7)
        for i in 0..<remainCount {
            dayOfMonthDateArray.append(date(byAdding: .day, value: i+1, to: compareDate))
        }
        return dayOfMonthDateArray
    }
}
