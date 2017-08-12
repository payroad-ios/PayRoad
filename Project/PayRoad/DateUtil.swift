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
    
    static func generateDatePeriod(from: Date, to: Date) -> [Date] {
        let numberOfDay = calendar.dateComponents([.day], from: from, to: to).day!
        
        var dateArray = [Date]()
        for i in 0...numberOfDay {
            let addingDate = calendar.date(byAdding: .day, value: i, to: from)!
            dateArray.append(addingDate)
        }
        return dateArray
    }
}

extension DateFormatter {
    static func stringToDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    static func stringTo(for date: Date, format: DateFormat) -> String {
        let formatter = DateFormatter()
        
        switch format {
        case .section:
            formatter.dateStyle = .long
            formatter.timeStyle = .none
        case .detail:
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
        }
        
        return formatter.string(from: date)
    }
}
