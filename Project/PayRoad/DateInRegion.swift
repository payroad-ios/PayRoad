//
//  DateInRegion.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 11..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

class DateInRegion: Object {
    
    dynamic var date = Date()
    private dynamic var _timeZone: String = TimeZone.current.identifier
    
    var timeZone: TimeZone {
        get { return TimeZone(identifier: _timeZone) ?? .current }
        set { _timeZone = timeZone.identifier }
    }
    
    var ymd: YMD {
        var calendar = Calendar.current
        calendar.timeZone = self.timeZone
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return YMD(year: year, month: month, day: day)
    }
    
    override static func ignoredProperties() -> [String] {
        return ["timeZone", "ymd"]
    }
}

// MARK: DateInRegion Formatter
extension DateInRegion {
    public func string() -> String {
        return DateFormatter.string(for: date, timeZone: timeZone)
    }
}
