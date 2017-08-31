//
//  ExtensionUIStoryboard.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 9..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UIStoryboard {
    //Mark: Travel
    static let TravelTableView = UIStoryboard(name: "TravelTableViewController", bundle: nil)
    static let TravelEditorView = UIStoryboard(name: "TravelEditorViewController", bundle: nil)
    
    //Mark: Trasaction
    static let TransactionTableView = UIStoryboard(name: "TransactionTableViewController", bundle: nil)
    static let TransactionEditorView = UIStoryboard(name: "TransactionEditorViewController", bundle: nil)
    static let TransactionDetailView = UIStoryboard(name: "TransactionDetailViewController", bundle: nil)
    
    //Mark: Map
    static let TransactionMapView = UIStoryboard(name: "TransactionMapViewController", bundle: nil)
    
    //Mark: Currency
    static let CurrencyTableView = UIStoryboard(name: "CurrencyTableViewController", bundle: nil)
    static let CurrencyEditorView = UIStoryboard(name: "CurrencyEditorViewController", bundle: nil)
    
    //Mark: Diary
    static let DiaryTableView = UIStoryboard(name: "DiaryTableViewController", bundle: nil)
    static let DiaryEditorView = UIStoryboard(name: "DiaryEditorViewController", bundle: nil)
    
    //Mark: Etc
    static let PhotoDetailView = UIStoryboard(name: "PhotoDetailViewController", bundle: nil)
    
    static func loadViewController(from storyboard: UIStoryboard, ID: String) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: ID)
        return viewController
    }
}
