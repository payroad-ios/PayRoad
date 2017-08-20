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
    dynamic var content: String = ""
    dynamic var isCash: Bool = true // credit is false
    dynamic var currency: Currency?
    dynamic var dateInRegion: DateInRegion?
    dynamic var category: Category?
    
    let lat = RealmOptional<Double>() // Latitude
    let lng = RealmOptional<Double>() // Longitude
    dynamic var placeID: String? = nil // 장소 ID
    dynamic var placeName: String? = nil // 장소명
    
    let photos = List<Photo>()
    let travel = LinkingObjects(fromType: Travel.self, property: "transactions")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
