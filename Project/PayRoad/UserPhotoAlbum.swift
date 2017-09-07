//
//  UserPhotoAlbum.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 19..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Photos

class UserPhotoAlbum {
    enum ImageSize {
        case thumbnail
        case original
        func convert() -> CGSize {
            switch self {
            case .thumbnail:
                return CGSize(width: 200, height: 200)
            case .original:
                return PHImageManagerMaximumSize
            }
        }
    }
    
    fileprivate let imageManager = PHImageManager.default()
    fileprivate let requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        return options
    }()
    
    fileprivate let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false, selector: nil)]
        return options
    }()
    
    fileprivate(set) lazy var fetchResult: PHFetchResult<PHAsset> = {
        let result = PHAsset.fetchAssets(with: .image, options: self.fetchOptions)
        return result
    }()
    
    
    func authorization(target: UIViewController, handler: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                handler()
            } else if status == .denied {
                UIAlertController.oneButtonAlert(target: target, title: "사진 앨범", message: "사진 앨범에 접근할 수 있는 권한이 없습니다.")
            }
        }
    }
    
    func requestImage(at: Int, imageSize: ImageSize, handler: @escaping (UIImage) -> Void) {
        self.imageManager.requestImage(for: self.fetchResult.object(at: at), targetSize: imageSize.convert(), contentMode: .aspectFit, options: self.requestOptions, resultHandler: { (image, error) in
            handler(image!)
        })
    }
    
    func count() -> Int {
        return fetchResult.count
    }
}

