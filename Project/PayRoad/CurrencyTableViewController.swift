//
//  CurrencyTableViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class CurrencyTableViewController: UIViewController {
    
    var travel: Travel!
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        notificationToken = RealmHelper.tableViewNotificationToken(for: tableView, list: travel.currencies)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCurrency",
            let navigationController = segue.destination as? UINavigationController,
            let addCurrencyTableViewController = navigationController.topViewController as? CurrencyEditorViewController {
            addCurrencyTableViewController.travel = travel
        }
    }

    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CurrencyTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        cell.textLabel?.text = travel.currencies[indexPath.row].code
        cell.detailTextLabel?.text = String(travel.currencies[indexPath.row].rate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.currencies.count
    }
}
