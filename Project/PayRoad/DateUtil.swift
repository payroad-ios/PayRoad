//
//  DateUtil.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 10..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

struct DateUtil {
    private static let defaultFormat = "YYYY월 MM월 dd일 HH:mm:ss"
    
    static let defaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultFormat
        //dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter
    }()
    
    static func dateKeyFromDate(from date: Date) -> Date {
        let dateFormatter = defaultFormatter
        //dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        print("aa \(dateFormatter.string(from: date))")
        
        //print(dateFormatter.string(from: Date()))
        guard let dateKey = dateFormatter.date(from: dateFormatter.string(from: date)) else {
            return Date(timeIntervalSince1970: 0)
        }
        
        print("bb \(dateKey)")
        return dateKey
    }
}
