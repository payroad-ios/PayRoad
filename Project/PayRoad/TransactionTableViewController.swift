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

    @IBOutlet weak var tableView: UITableView!
    var notificationToken: NotificationToken? = nil
    var travel: Travel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = travel.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        notificationToken = travel.transactions.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
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

extension TransactionTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        let transaction = travel.transactions[indexPath.row]
        cell.textLabel?.text = transaction.name
        cell.detailTextLabel?.text = "\(transaction.currency?.code ?? "") \(transaction.amount)"
        
        return cell
    }
}
