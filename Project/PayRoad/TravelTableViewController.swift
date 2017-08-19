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
    
    let tempBackgroundBGArray = [#imageLiteral(resourceName: "SampleBG_Rome"), #imageLiteral(resourceName: "SampleBG_Paris"), #imageLiteral(resourceName: "SampleBG_Seoul"), #imageLiteral(resourceName: "SampleBG_Franch"), #imageLiteral(resourceName: "SampleBG_JeonJu"), #imageLiteral(resourceName: "SampleBG_London"), #imageLiteral(resourceName: "SampleBG_NewYork"), #imageLiteral(resourceName: "SampleBG_NewYork2"), #imageLiteral(resourceName: "SampleBG_HongKong")]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = ColorStore.unselectGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        
        notificationToken = travels.addNotificationBlock({ (changes: RealmCollectionChange) in
            self.tableView.reloadData()
        })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as! TravelTableViewCell
        
        let travel = travels[indexPath.row]
        cell.travelView.travelNameLabel.text = travel.name
        cell.travelView.fillDatePeriodLabel(startDate: travel.startDateInRegion!.date, endDate: travel.endDateInRegion!.date)
        
        guard let fileURL = travel.photo?.fileURL else {
            return cell
        }
        cell.travelView.backgroundImage.image = FileUtil.loadImageFromDocumentDir(filePath: fileURL)
        
        //image Random Setting
//        cell.travelView.backgroundImage.image = tempBackgroundBGArray[Int(arc4random_uniform(UInt32(tempBackgroundBGArray.count)))]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
