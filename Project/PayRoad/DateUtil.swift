//
//  DateUtil.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 10..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

struct DateUtil {
    private static let calendar = Calendar.current
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        return dateFormatter
    }()
    
    static func extractDatePeriod(from: Date, to: Date) -> [Date] {
        let numberOfDay = calendar.dateComponents([.day], from: from, to: to).day!
        
        var dateArray = [Date]()
        for i in 0...numberOfDay {
            let addingDate = calendar.date(byAdding: .day, value: i, to: from)!
            dateArray.append(addingDate)
        }
        return dateArray
    }
    
    static func generateYMDPeriod(from fromYMD: YMD, to toYMD: YMD) -> [YMD] {
        var ymds = [YMD]()
        var ymd = fromYMD
        while ymd <= toYMD {
            ymds.append(ymd)
            ymd.add(day: 1)
        }
        return ymds
    }
}

extension DateFormatter {
    static func stringToDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
}
