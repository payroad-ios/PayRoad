//
//  AppInitial.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 17..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation
import RealmSwift

class RealmInitializer {

    private static let realm = try! Realm()
    
    static func initializeCategories() {
        
        let resultsCategory = realm.objects(Category.self)
        
        if resultsCategory.count == 0 {
            
            var categories = [Category]()
            
            let category1 = Category()
            category1.id = "category-food"
            category1.name = "식비"
            category1.assetName = "Category_Food"
            categories.append(category1)
            
            let category2 = Category()
            category2.id = "category-shopping"
            category2.name = "쇼핑"
            category2.assetName = "Category_Shopping"
            categories.append(category2)
            
            let category3 = Category()
            category3.id = "category-tour"
            category3.name = "관광"
            category3.assetName = "Category_Tour"
            categories.append(category3)
            
            let category4 = Category()
            category4.id = "category-transport"
            category4.name = "교통"
            category4.assetName = "Category_Transport"
            categories.append(category4)
            
            let category5 = Category()
            category5.id = "category-lodge"
            category5.name = "숙박"
            category5.assetName = "Category_Lodge"
            categories.append(category5)
            
            let category6 = Category()
            category6.id = "category-etc"
            category6.name = "기타"
            category6.assetName = "Category_Etc"
            categories.append(category6)
            
            for category in categories {
                try? realm.write {
                    realm.add(category)
                }
            }
        }
    }
}
