//
//  Device.swift
//  PayRoad
//
//  Created by Febrix on 2018. 1. 4..
//  Copyright © 2018년 REFUEL. All rights reserved.
//

import UIKit

struct Device {
    enum iPhone {
        case iPhone5s
        case iPhone8
        case iPhone8plus
        case iPhoneX
        case unknown
    }
    
    static let currentDevice: iPhone = {
        return getDeviceModel()
    }()
    
    private static func getDeviceModel() -> iPhone {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return .iPhone5s
            case 1334:
                print("iPhone 6/6S/7/8")
                return .iPhone8
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                return .iPhone8plus
            case 2436:
                print("iPhone X")
                return .iPhoneX
            default:
                print("unknown")
                return .unknown
            }
        }
        return .unknown
    }
}
