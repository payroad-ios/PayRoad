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
        tableView.tableFooterView = UIView()
        
        notificationToken = travel.currencies.addNotificationBlock({ (changes: RealmCollectionChange) in
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCurrency" {
            guard let navigationController = segue.destination as? UINavigationController,
            let addCurrencyTableViewController = navigationController.topViewController as? CurrencyEditorViewController
            else {
                return
            }
            
            addCurrencyTableViewController.travel = travel
        }
        
        if segue.identifier == "editCurrency" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let navigationController = segue.destination as? UINavigationController,
                let editCurrencyTableViewController = navigationController.topViewController as? CurrencyEditorViewController
            else {
                return
            }
            
            editCurrencyTableViewController.editorMode = .edit
            editCurrencyTableViewController.travel = travel
            editCurrencyTableViewController.originCurrency = travel.currencies[indexPath.row]
        }
    }

    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CurrencyTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyBudgetTableViewCell", for: indexPath) as! CurrencyBudgetTableViewCell
        
        let currency = travel.currencies[indexPath.row]
        cell.currencyCodeLabel?.text = currency.code
        cell.currencyLocaleLabel?.text = Locale.current.localizedString(forCurrencyCode: currency.code)
        cell.budgetAmountLabel?.text = NumberStringUtil.roughString(number: currency.budget)
        
        if currency.rate == 1.0 {
            cell.rateLabel?.text = "기준"
        } else {
            let basicCurrencyCode = travel.currencies.first!.code
            cell.rateLabel?.text = "1\(currency.code)당 \(NumberStringUtil.roughString(number: currency.rate))\(basicCurrencyCode)"
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.currencies.count
    }
}
