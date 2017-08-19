//
//  UserPhotoAlbum.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 19..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Photos

class UserPhotoAlbum {
    let targetImageSize = CGSize(width: 200, height: 200)
    let imageManager = PHImageManager.default()
    
    let requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        return options
    }()
    
    let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false, selector: nil)]
        return options
    }()
    
    lazy var fetchResult: PHFetchResult<PHAsset> = {
        let result = PHAsset.fetchAssets(with: .image, options: self.fetchOptions)
        return result
    }()
    
    
    func authorization(target: UIViewController, handler: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                handler()
            } else if status == .denied {
                print("실패")
                //TODO: 실패 Alert 출력
            }
        }
    }
    
    func requestImage(at: Int, handler: @escaping (UIImage) -> Void) {
        self.imageManager.requestImage(for: self.fetchResult.object(at: at), targetSize: self.targetImageSize, contentMode: .aspectFill, options: self.requestOptions, resultHandler: { (image, error) in
            handler(image!)
        })
    }
    
    func count() -> Int {
        return fetchResult.count
    }
}

