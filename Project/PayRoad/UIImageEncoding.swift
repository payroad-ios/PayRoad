//
//  UIImageEncoding.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 13..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func data() -> Data {
        var imageData = UIImagePNGRepresentation(self)
        // Resize the image if it exceeds the 2MB limit
        if (imageData?.count)! > 2097152 {
            let oldSize = self.size
            let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            let newImage = self.resizeImage(self, size: newSize)
            imageData = UIImageJPEGRepresentation(newImage, 0.7)
        }
        return imageData!
    }
}
