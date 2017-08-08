//
//  TravelViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class TransactionTableViewController: UIViewController {

    var travel: Travel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCurrencies" {
            let navigationController = segue.destination as! UINavigationController
            let currencyTableViewController = navigationController.topViewController as! CurrencyTableViewController
            currencyTableViewController.travel = travel
        } else if segue.identifier == "addTransaction" {
            let navigationController = segue.destination as! UINavigationController
            let addTransactionTableViewController = navigationController.topViewController as! AddTransactionViewController
            addTransactionTableViewController.travel = travel
        }
    }
    
    
    
//    dynamic var id = UUID().uuidString
//    dynamic var name = ""
//    dynamic var amount: Double = 0.0
//    dynamic var date = Date()
//    dynamic var timeZone: String = ""
//    dynamic var content: String = ""
}
