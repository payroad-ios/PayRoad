//
//  Transaction.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

class Transaction: Object {
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    dynamic var amount: Double = 0.0
    dynamic var currency: Currency?
    
    // Date: Date
    dynamic var date = Date()
    dynamic var timeZone: String = ""
    
    dynamic var content: String = ""
    
    let travel = LinkingObjects(fromType: Travel.self, property: "transactions")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
