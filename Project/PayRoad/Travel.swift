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
    
    let transactions = List<Transaction>()
    let currencies = List<Currency>()
    
    override static func primaryKey() -> String? {
        return "id"
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
        
        return objectList
    }
}
