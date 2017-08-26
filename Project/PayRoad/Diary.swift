//
//  Diary.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 18..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

class Diary: Object {
    dynamic var id = UUID().uuidString
    
    dynamic var _year = 1970
    dynamic var _month = 1
    dynamic var _day = 1
    
    var ymd: YMD {
        get {
            return YMD(year: _year, month: _month, day: _day)
        }
        set {
            _year = newValue.year
            _month = newValue.month
            _day = newValue.day
        }
    }
    
    dynamic var content = ""
    dynamic var updatedAt: DateInRegion?
    
    let travel = LinkingObjects(fromType: Travel.self, property: "diaries")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["ymd"]
    }
}
