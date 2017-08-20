//
//  Photo.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 14..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import RealmSwift

class Photo: Object {
    dynamic var travelID = ""
    dynamic var preID = ""
    dynamic var photoID = UUID().uuidString
    dynamic var fileType = "jpg"
    
    var fileName: String {
        return "\(preID)\(photoID).\(fileType)"
    }
    
    var filePath: String {
        return "\(travelID)/image/\(fileName)"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["fileURL", "fileName"]
    }
    
    let transaction = LinkingObjects(fromType: Transaction.self, property: "photos")
}

extension Photo {
    func fetchPhoto() -> UIImage? {
        return PhotoUtil.loadPhotoFrom(filePath: filePath)
    }
    
    func fetchPhotoFromAssets() -> UIImage? {
        return UIImage(named: fileName)
    }
}
