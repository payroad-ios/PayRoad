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
    dynamic var startDateInRegion: DateInRegion?
    dynamic var endDateInRegion: DateInRegion?
    dynamic var photo: Photo?
    var totalAmount: Double?
    
    let transactions = List<Transaction>()
    let currencies = List<Currency>()
    let diaries = List<Diary>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["totalAmount"]
    }
    
    func stringTotalAmount() -> String {
        totalAmount = transactions.reduce(0) { $0.0 + $0.1.amount * $0.1.currency!.rate }
        return "\(currencies.first!.code) \(totalAmount!.nonZeroString(maxDecimalPlace: 2, option: .seperator))"
    }
}

extension Travel: CascadingDeletable {
    func childrenToDelete() -> [AnyObject?] {
        var objectList = [AnyObject?]()
        
        objectList.append(startDateInRegion)
        objectList.append(endDateInRegion)
        objectList.append(photo)
        objectList.append(transactions)
        objectList.append(currencies)
        objectList.append(diaries)
        
        return objectList
    }
}
