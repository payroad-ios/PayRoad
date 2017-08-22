//
//  Category.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 15..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    dynamic var assetName = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
