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

//Category Class를 Local 모델로 갖고 Transaction은 Category Index를 가지는게 어떤지
class CategoryTEST {
    var index: Int
    var image: UIImage
    var name: String
    init(index: Int, name: String, image: UIImage) {
        self.index = index
        self.name = name
        self.image = image
    }
}

class CategoryStore {
    static let shard = CategoryStore()
    var categorys = [CategoryTEST]()
    init() {
        for i in 0..<10 {
            if i % 2 == 0 {
                let category = CategoryTEST(index: 0, name: "교통", image: #imageLiteral(resourceName: "Category_Transportation"))
                categorys.append(category)
                
            } else {
                let category = CategoryTEST(index: 1, name: "식비", image: #imageLiteral(resourceName: "Category_Food"))
                categorys.append(category)
            }
        }
    }
}
