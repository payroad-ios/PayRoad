//
//  TransactionPopUpViewController.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 21..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class TransactionPopUpViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var transaction: Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = transaction.name
        dateLabel.text = transaction.dateInRegion?.string()
        amountLabel.text = "\(transaction.amount) \(transaction.currency!.code)"
    }

    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

}
