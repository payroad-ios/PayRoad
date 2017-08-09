//
//  ExtensionUIStoryboard.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 9..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static let CurrencyTableView = UIStoryboard(name: "CurrencyTableViewController", bundle: nil)
    static let TransactionTableView = UIStoryboard(name: "TransactionTableViewController", bundle: nil)
    static let TransactionEditorView = UIStoryboard(name: "TransactionEditorViewController", bundle: nil)
    static let CurrencyEditorView = UIStoryboard(name: "CurrencyEditorViewController", bundle: nil)
    static let TravelTableView = UIStoryboard(name: "TravelTableViewController", bundle: nil)
    static let TravelEditorView = UIStoryboard(name: "TravelEditorViewController", bundle: nil)
    
    static func loadViewController(from storyboard: UIStoryboard, ID: String) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: ID)
        return viewController
    }
}
