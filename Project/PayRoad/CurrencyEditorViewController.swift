//
//  AddCurrencyViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class CurrencyEditorViewController: UIViewController {
    
    let realm = try! Realm()
    
    var travel: Travel!
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        let currency = Currency()
        
        
        guard let code = codeTextField.text,
            let rateText = rateTextField.text,
            let rate = Double(rateText) else { return }
        
        currency.code = code
        currency.rate = rate
        
        do {
            try realm.write {
                travel.currencies.append(currency)
                print("Currency 추가")
                dismiss(animated: true, completion: nil)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
