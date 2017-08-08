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
    
    let transactions = List<Transaction>()
    let currencies = List<Currency>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
