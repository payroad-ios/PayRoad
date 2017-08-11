//
//  DateInRegion.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 11..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

enum DateFormat {
    case section
    case detail
}

class DateInRegion: Object {
    
    dynamic var date = Date()
    dynamic var _timeZone: String = ""
    
    var timeZone: TimeZone {
        get { return TimeZone(identifier: _timeZone) ?? .current }
        set { _timeZone = timeZone.identifier }
    }

    override static func ignoredProperties() -> [String] {
        return ["timeZone"]
    }
}

// MARK: DateInRegion Formatter

extension DateInRegion {
    
    public func string(format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = self.timeZone
        
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
