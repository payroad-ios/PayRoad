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
        set { _timeZone = newValue.identifier }
    }
    
    var ymd: YMD {
        return YMD(date: self.date, timeZone: self.timeZone)
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
