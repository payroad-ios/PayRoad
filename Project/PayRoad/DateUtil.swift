//
//  DateUtil.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 10..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

struct DateUtil {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        return dateFormatter
    }()
    
    //TODO: 함수명 변경해야될것 같음
    static func dateKeyFromDate(from date: Date) -> Date? {
        let df: DateFormatter = {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .none
            
            return df
        }()
        
        df.timeZone = TimeZone.current
        let dateString = df.string(from: date)
        
        df.timeZone = TimeZone(identifier: "UTC")
        df.date(from: dateString)
        
        guard let dateKey = df.date(from: dateString) else {
            return nil
        }
        
        return dateKey
    }
}
