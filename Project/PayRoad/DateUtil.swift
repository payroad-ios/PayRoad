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
}
