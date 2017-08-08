//
//  TravelViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class TransactionTableViewController: UIViewController {
    
    var travel: Travel!
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = travel.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        notificationToken = tableViewNotificationToken(for: tableView, list: travel.transactions)
    }
    
    //TODO: 스트링 길다. 나중에 자릅시다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCurrencies" {
            guard let navigationController = segue.destination as? UINavigationController,
                let currencyTableViewController = navigationController.topViewController as? CurrencyTableViewController
            else {
                return
            }
            
            currencyTableViewController.travel = travel
        } else if segue.identifier == "addTransaction" {
            guard let navigationController = segue.destination as? UINavigationController,
                let addTransactionTableViewController = navigationController.topViewController as? TransactionEditorViewController
            else {
                return
            }
            addTransactionTableViewController.travel = travel
        }
    }
}

extension TransactionTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        let transaction = travel.transactions[indexPath.row]
        cell.textLabel?.text = transaction.name
//        cell.detailTextLabel?.text = "\(transaction.currency?.code ?? "") \(transaction.amount)"
        
        let attributedString = NSMutableAttributedString(string: "\(transaction.currency?.code ?? "") \(transaction.amount)")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location: 0, length: 3))
        cell.detailTextLabel?.attributedText = attributedString
        
        return cell
    }
}
