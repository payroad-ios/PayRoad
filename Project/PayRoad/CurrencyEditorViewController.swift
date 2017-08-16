//
//  AddCurrencyViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class CurrencyEditorViewController: UIViewController, CurrencySelectTableViewControllerDelegate, UITextFieldDelegate {
    
    enum Mode {
        case new
        case edit
    }
    
    let realm = try! Realm()
    
    var travel: Travel!
    var originCurrency: Currency!
    var standardCurrency: Currency!
    var editedCurrency: Currency!
    
    var mode: Mode = .new
    
    @IBOutlet weak var currencySelectButton: UIButton!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var lastUpdateDateLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var updateRateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.standardCurrency = travel.currencies.first!
        rateTextField.delegate = self
        budgetTextField.delegate = self
        
        self.adjustViewMode()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === rateTextField {
            rateTextField.text = String(editedCurrency.rate)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === rateTextField {
            editedCurrency.rate = Double(textField.text ?? "0") ?? 0
            let standard = travel.currencies.first!.code
            let code = currencySelectButton.title(for: .normal)!
            
            self.rateTextField.text = "1 \(code)당, \(editedCurrency.rate) \(standard)"
        }
        textField.endEditing(true)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateRateButtonDidTap(_ sender: Any) {
        guard let code = currencySelectButton.title(for: .normal) else {
            return
        }
        
        currencySelectResponse(code: code)
    }
    
    func currencySelectResponse(code: String) {
        currencySelectButton.setTitle(code, for: .normal)
        let standard = travel.currencies.first!.code
        exchangeRateFromAPI(standard: standard, compare: code) { [unowned self] rate in
            OperationQueue.main.addOperation {
                self.rateTextField.isEnabled = true
                self.updateRateButton.isEnabled = true
                self.rateTextField.textColor = self.rateTextField.textColor?.withAlphaComponent(0.6)
                self.rateTextField.text = "1 \(code)당, \(rate) \(standard)"
                self.lastUpdateDateLabel.text = DateFormatter.string(for: Date(), timeZone: TimeZone.current)
                
                self.editedCurrency.code = code
                self.editedCurrency.rate = Double(rate) ?? 0
            }
        }
    }
    
    func exchangeRateFromAPI(standard: String, compare: String, completion: @escaping (String) -> Void) {
        let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22\(standard)\(compare)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
            guard let jsonObject = jsonData as? [String: Any],
                let query = jsonObject["query"] as? [String: Any],
                let results = query["results"] as? [String: Any],
                let result = results["rate"] as? [String: String],
                let rate = result["Rate"]
                else {
                    return
            }
            completion(rate)
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

extension CurrencyEditorViewController {
    fileprivate func adjustViewMode() {
        self.editedCurrency = Currency()
        if let originRate = originCurrency?.rate {
            editedCurrency.rate = originRate
        }
        
        switch self.mode {
        case .new:
            let saveBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: #selector(saveButtonDidTap))
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
            
            self.rateTextField.isEnabled = false
            self.updateRateButton.isEnabled = false
        case .edit:
            self.navigationItem.title = "예산 수정"
            let editBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: #selector(editButtonDidTap))
            self.navigationItem.rightBarButtonItem = editBarButtonItem
            
            self.currencySelectButton.setTitle(originCurrency.code, for: .normal)
            self.currencySelectButton.isEnabled = false
            
            //self.rateTextField.isEnabled = false
            self.budgetTextField.text = String(originCurrency.budget)
            
            if originCurrency.code == standardCurrency.code {
                rateTextField?.text = "기준 통화"
            } else {
                rateTextField?.text = "1 \(originCurrency.code)당 \(originCurrency.rate)\(standardCurrency.code)"
            }
        }
    }
    
    func saveButtonDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        var currency = Currency()
        currentyFromUI(currency: &currency)
        
        do {
            try realm.write {
                travel.currencies.append(currency)
                print("Currency 추가")
            }
        } catch {
            print(error)
        }
    }
    
    func editButtonDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        var currency = Currency()
        currentyFromUI(currency: &currency)
        
        do {
            try realm.write {
                originCurrency.code = currency.code
                originCurrency.rate = currency.rate
                originCurrency.budget = currency.budget
                print("통화 수정")
            }
        } catch {
            print(error)
        }
    }
    
    func currentyFromUI(currency: inout Currency) {
        
        guard let code = currencySelectButton.title(for: .normal),
            let budgetText = budgetTextField.text,
            let budget = Double(budgetText)
        else {
                print("fail to get currency from UI")
                return
        }
        
        currency.code = code
        
        currency.rate = editedCurrency.rate
        currency.budget = budget
    }
    
    func deleteCurrencyButtonDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        try! realm.write {
            self.realm.delete(originCurrency)
        }
    }
}

