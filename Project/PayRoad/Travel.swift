//
//  Travel.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

class Travel: Object {
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    dynamic var starteDate = Date()
    dynamic var endDate = Date()
    
    dynamic var startYear = 0
    dynamic var startMonth = 0
    dynamic var startDay = 0
    dynamic var endYear = 0
    dynamic var endMonth = 0
    dynamic var endDay = 0
    
    let transactions = List<Transaction>()
    let currencies = List<Currency>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
