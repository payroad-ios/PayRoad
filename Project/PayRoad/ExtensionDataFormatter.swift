//
//  ExtensionDataFormatter.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 16..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension DateFormatter {
    static func stringToDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func string(for date: Date, timeZone: TimeZone?) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
    }
}
