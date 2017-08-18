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

// getFilePath
// saveImage
// loadImage
// removeImage
// containPath

enum DirectoryType: String {
    case image = "image"
}

struct FileUtil {
    static func generateDirectoryPath(travelID: String, directory: DirectoryType? = nil) -> String {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentURL.appendingPathComponent("travel", isDirectory: true)
        guard let _ = directory else {
            return fileURL.appendingPathComponent(travelID, isDirectory: true).path
        }
        return fileURL.appendingPathComponent(travelID, isDirectory: true).appendingPathComponent(directory!.rawValue, isDirectory: true).path
    }
    
    static func getFileURLPathFrom(_ filePath: String) -> String? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentURL.appendingPathComponent("travel", isDirectory: true).appendingPathComponent(filePath)
        return fileURL.path
    }
    
    static func removeAllData(travelID: String) -> Bool {
        let directoryPath = generateDirectoryPath(travelID: travelID)
        
        do {
            print("디렉토리", directoryPath)
            try FileManager.default.removeItem(atPath: directoryPath)
        } catch {
            return false
        }
        return true
    }
}

struct PhotoUtil {
    private let travelID: String
    
    init(travelID: String) {
        self.travelID = travelID
    }
    
    func saveTransactionPhoto(transactionID: String, photo: UIImage) -> Photo {
        let photoModel = Photo()
        photoModel.travelID = travelID
        photoModel.preID = transactionID.substring(to: 8)
        
        let directoryPath = FileUtil.generateDirectoryPath(travelID: travelID, directory: .image)
        let isSuccess = writePhotoToDocument(photo: photo, directoryPath: directoryPath, fileName: photoModel.fileName)
        print(isSuccess ? "저장 성공" : "저장 실패")
        return photoModel
    }
    
    func saveCoverPhoto(photo: UIImage) -> Photo {
        let photoModel = Photo()
        photoModel.travelID = travelID
        
        let directoryPath = FileUtil.generateDirectoryPath(travelID: travelID, directory: .image)
        let isSuccess = writePhotoToDocument(photo: photo, directoryPath: directoryPath, fileName: photoModel.fileName)
        print(isSuccess ? "저장 성공" : "저장 실패")
        return photoModel
    }
    
    private func writePhotoToDocument(photo: UIImage, directoryPath: String, fileName: String) -> Bool {
        let imageData = photo.data()
        let url = URL(fileURLWithPath: directoryPath + "/" + fileName)
        do {
            try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            try imageData.write(to: url, options: [.atomic])
        } catch {
            return false
        }
        return true
    }
    
    static func loadPhotoFrom(filePath: String) -> UIImage? {
        guard let imageData = FileUtil.getFileURLPathFrom(filePath) else {
            return nil
        }
        
        guard let image = UIImage(contentsOfFile: imageData)
            else {
                print("fail to load image \(imageData)")
                return nil
        }
        
        return image
    }
    
    static func deletePhoto(filePath: String) -> Bool {
        guard let imagePath = FileUtil.getFileURLPathFrom(filePath) else {
            return false
        }
        
        do {
            try FileManager.default.removeItem(atPath: imagePath)
        } catch {
            print(error.localizedDescription)
        }
        return true
    }
}

