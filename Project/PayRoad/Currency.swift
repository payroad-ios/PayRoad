//
//  Currency.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation
import RealmSwift

class Currency: Object {
    dynamic var id = UUID().uuidString
    dynamic var code = ""
    dynamic var rate: Double = 1.0
    
    let travel = LinkingObjects(fromType: Travel.self, property: "currencies")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
