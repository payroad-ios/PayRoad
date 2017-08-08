//
//  AddTransactionViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    
    var travel: Travel!

    override func viewDidLoad() {
        super.viewDidLoad()

        for currency in travel.currencies {
            print("\(currency.code) : \(currency.rate)")
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        let transaction = Transaction()
        
        
        guard let name = nameTextField.text,
            let amountText = amountTextField.text,
            let amount = Double(amountText),
            let currency = currencyTextField.text else { return }
        
        transaction.name = name
        transaction.amount = amount
        //        transaction.currency = currency
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

}
