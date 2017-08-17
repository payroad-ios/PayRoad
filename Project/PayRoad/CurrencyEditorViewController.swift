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
        rateTextField.addTarget(self, action: #selector(editingChangedRate(_:)), for: .editingChanged)
        budgetTextField.addTarget(self, action: #selector(editingChangedBudget(_:)), for: .editingChanged)
        adjustViewMode()
    }
    
    func editingChangedRate(_ sender: UITextField) {
        guard let rateText = sender.text,
            let rate = Double(rateText)
        else {
            return
        }
        
        editedCurrency.rate = rate
    }
    
    func editingChangedBudget(_ sender: UITextField) {
        guard let budgetText = sender.text,
            let budget = Double(budgetText)
        else {
            return
        }
        
        editedCurrency.budget = budget
    }
    
    func checkIsExistInputField() -> Bool {
        guard !(editedCurrency.code == "") else {
            UIAlertController.oneButtonAlert(target: self, title: "에러", message: "화폐를 선택해주세요.")
            return false
        }
        
        guard !(budgetTextField.text!.isEmpty) else {
            UIAlertController.oneButtonAlert(target: self, title: "에러", message: "예산을 입력해주세요..")
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCurrencyCode" {
            let currencySelectTableViewController = segue.destination as! CurrencySelectTableViewController
            currencySelectTableViewController.delegate = self
        }
    }
    
    //MARK: Actions
    @IBAction func backgroundDidTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateRateButtonDidTap(_ sender: Any) {
        guard let code = currencySelectButton.title(for: .normal) else {
            return
        }
        
        currencySelectResponse(code: code)
    }
}

extension CurrencyEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === rateTextField {
            rateTextField.text = String(editedCurrency.rate)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === rateTextField {
            let standard = travel.currencies.first!.code
            let code = currencySelectButton.title(for: .normal)!
            textField.text = "1 \(code)당, \(editedCurrency.rate) \(standard)"
            
        } else if textField === budgetTextField {
            textField.text = String(editedCurrency.budget)
        }
        
        textField.endEditing(true)
    }
}

extension CurrencyEditorViewController: CurrencySelectTableViewControllerDelegate {
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
                self.navigationItem.rightBarButtonItem?.isEnabled = true
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
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension CurrencyEditorViewController {
    fileprivate func adjustViewMode() {
        editedCurrency = Currency()
        
        if originCurrency != nil {
            editedCurrency.code = originCurrency.code
            editedCurrency.rate = originCurrency.rate
            editedCurrency.budget = originCurrency.budget
        }
        
        switch self.mode {
        case .new:
            let saveBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: #selector(saveButtonDidTap))
            navigationItem.rightBarButtonItem = saveBarButtonItem
            
            rateTextField.isEnabled = false
            updateRateButton.isEnabled = false
        case .edit:
            navigationItem.title = "예산 수정"
            
            let editBarButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: #selector(editButtonDidTap))
            navigationItem.rightBarButtonItem = editBarButtonItem
            
            currencySelectButton.setTitle(originCurrency.code, for: .normal)
            currencySelectButton.isEnabled = false
            
            budgetTextField.text = String(originCurrency.budget)
            
            if originCurrency.code == standardCurrency.code {
                rateTextField.text = "기준 통화"
                rateTextField.isEnabled = false
                updateRateButton.isEnabled = false
            } else {
                rateTextField.text = "1 \(originCurrency.code)당 \(originCurrency.rate)\(standardCurrency.code)"
            }
        }
    }
    
    func saveButtonDidTap() {
        if checkIsExistInputField() {
            let currency = Currency()
            currency.code = editedCurrency.code
            currency.rate = editedCurrency.rate
            currency.budget = editedCurrency.budget
            
            do {
                try realm.write {
                    travel.currencies.append(currency)
                    print("Currency 추가")
                }
            } catch {
                print(error)
            }
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func editButtonDidTap() {
        if checkIsExistInputField() {
            do {
                try realm.write {
                    originCurrency.code = editedCurrency.code
                    originCurrency.rate = editedCurrency.rate
                    originCurrency.budget = editedCurrency.budget
                    print("통화 수정")
                }
            } catch {
                print(error)
            }
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
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

