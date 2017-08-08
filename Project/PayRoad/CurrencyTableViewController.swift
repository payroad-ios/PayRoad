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
    
    @IBOutlet weak var tableView: UITableView!
    
    var travel: Travel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCurrency" {
            let navigationController = segue.destination as! UINavigationController
            let addCurrencyTableViewController = navigationController.topViewController as! AddCurrencyViewController
            addCurrencyTableViewController.travel = travel
        }
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
