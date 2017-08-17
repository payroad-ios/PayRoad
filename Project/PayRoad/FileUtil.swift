//
//  FileUtil.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 14..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

enum PhotoFormat: String {
    case jpg = "jpg"
    case png = "png"
}

struct FileUtil {
    private static func filePathForDocumentDir(_ filename: String) -> String? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else {
                print("fail to get document URL")
                return nil
        }
        
        let fileURL = documentURL.appendingPathComponent(filename)
        return fileURL.path
    }
    
    static func saveImageToDocumentDir(_ image: UIImage, filePath: String) {
        guard let imagePath = filePathForDocumentDir(filePath) else {
            return
        }
        
        let imageData = image.data()
        
        try? imageData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
    }
    
    static func saveNewImage(image: UIImage, format: PhotoFormat = .jpg) -> Photo {
        let photo = Photo()
        photo.id = UUID().uuidString
        photo.fileType = format.rawValue

        FileUtil.saveImageToDocumentDir(image, filePath: photo.fileURL)
        return photo
    }
    
    static func loadImageFromDocumentDir(filePath: String) -> UIImage? {
        guard let imagePath = filePathForDocumentDir(filePath) else {
            return nil
        }
        
        guard let image = UIImage(contentsOfFile: imagePath)
            else {
                print("fail to load image \(filePath)")
                return nil
        }
        
        return image
    }
    
    static func removeImageOnDocumentDir(filePath: String) {
        guard let imagePath = filePathForDocumentDir(filePath) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: imagePath)
        } catch {
            print(error.localizedDescription)
        }
    }
}
