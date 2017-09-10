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
    
    fileprivate let travels: Results<Travel> = {
        let realm = try! Realm()
        return realm.objects(Travel.self)
    }()
    fileprivate var notificationToken: NotificationToken? = nil
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noticeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = ColorStore.unselectGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Logo_PayRoad-Small"))
        notificationToken = travels.addNotificationBlock({ (changes: RealmCollectionChange) in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noticeLabel.isHidden = travels.isEmpty ? false : true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransactions",
            let indexPath = tableView.indexPathForSelectedRow,
            let transactionTableViewController = segue.destination as? TransactionTableViewController {
            transactionTableViewController.set(travel: travels[indexPath.row])
        }
    }
    
    func pushNewTravelViewController(object: Travel) {
        let transactionTableViewController = UIStoryboard.loadViewController(from: .TransactionTableView, ID: "Travel") as! TransactionTableViewController
        transactionTableViewController.set(travel: object)
        navigationController?.pushViewController(transactionTableViewController, animated: true)
    }
    
    deinit {
        notificationToken?.stop()
    }
}


extension TravelTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as! TravelTableViewCell
        
        let travel = travels[indexPath.row]
        cell.travelView.travelNameLabel.text = travel.name
        cell.travelView.fillDatePeriodLabel(startDate: travel.startDateInRegion!.date, endDate: travel.endDateInRegion!.date)
        
        guard let photo = travel.photo else {
            return cell
        }
        cell.travelView.backgroundImage.image = photo.fetchPhoto()
        
        guard let code = travel.currencies.first?.code else {
            return cell
        }
        
        cell.travelView.spendingAmountLabel.text = travel.stringTotalAmount()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
