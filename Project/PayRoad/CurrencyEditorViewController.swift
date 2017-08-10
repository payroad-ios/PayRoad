//
//  AddCurrencyViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class CurrencyEditorViewController: UIViewController, CurrencySelectTableViewControllerDelegate {
    
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
    
    func currencySelectResponse(code: String) {
        codeTextField.text = code
        
        guard let firstCode = travel.currencies.first?.code else {
            return
        }
        
        guard let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22\(firstCode)\(code)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let jsonObject = jsonData as? [String: Any],
                let query = jsonObject["query"] as? [String: Any],
                let results = query["results"] as? [String: Any],
                let result = results["rate"] as? [String: String] {
                
                if let rate = result["Rate"] {
                    OperationQueue.main.addOperation {
                            self.rateTextField.text = rate
                    }
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCurrencyCode" {
            let currencySelectTableViewController = segue.destination as! CurrencySelectTableViewController
            currencySelectTableViewController.delegate = self
        }
    }
}
