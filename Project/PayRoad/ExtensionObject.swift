//
//  ExtensionObject.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 22..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

protocol CascadingDeletable {
    func childrenToDelete() -> [AnyObject?]
}

extension List: CascadingDeletable {
    public func childrenToDelete() -> [AnyObject?] {
        return self.flatMap{ $0 }
    }
}

extension Object {
    static func cascadingDelete(realm: Realm, object: AnyObject?) {
        if let deletable = object as? CascadingDeletable {
            deletable.childrenToDelete().forEach{ child in
                cascadingDelete(realm: realm, object: child)
            }
        }
        
        if let realmObject = object as? Object {
            try! realm.write({
                realm.delete(realmObject)
            })
        }
    }
}
