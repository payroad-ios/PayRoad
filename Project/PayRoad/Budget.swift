//
//  Budget.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 15..
//  Copyright © 2017년 REFUEL. All rights reserved.
//
import RealmSwift

class Budget: Object {
    dynamic var id = UUID().uuidString
    dynamic var amount = 0
    dynamic var currency: Currency?
}
