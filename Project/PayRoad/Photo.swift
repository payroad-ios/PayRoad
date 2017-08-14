//
//  Photo.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 14..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

class Photo: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var fileType = ""
    
    var fileURL: String {
        return "\(id).\(fileType)"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["fileURL"]
    }
    
    let transaction = LinkingObjects(fromType: Transaction.self, property: "photos")
}
