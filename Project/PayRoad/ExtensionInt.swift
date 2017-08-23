//
//  ExtensionInt.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 24..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

extension Int {
    func stringThousandsSeparator() -> String {
        return String().thousandsSeparator(integer: self)
    }
}
