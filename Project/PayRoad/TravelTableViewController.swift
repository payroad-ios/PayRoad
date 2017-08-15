//
//  ViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class TravelTableViewController: UIViewController {
    
    let travels: Results<Travel> = {
        let realm = try! Realm()
        return realm.objects(Travel.self)
    }()
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = ColorStore.unselectGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        notificationToken = RealmHelper.tableViewNotificationToken(for: tableView, results: travels)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransactions",
            let indexPath = tableView.indexPathForSelectedRow,
            let transactionTableViewController = segue.destination as? TransactionTableViewController {
            transactionTableViewController.travel = travels[indexPath.row]
        }
    }
    
    deinit {
        notificationToken?.stop()
    }
}


extension TravelTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = travels[indexPath.row].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
