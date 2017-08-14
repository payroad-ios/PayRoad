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
    
    enum Mode {
        case new
        case edit
    }
    
    let realm = try! Realm()
    
    var travel: Travel!
    var originCurrency: Currency!
    var mode: Mode = .new
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adjustViewMode()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func currencySelectResponse(code: String) {
        codeTextField.text = code
        
        exchangeRateFromAPI(standard: travel.currencies.first!.code, compare: code) { [unowned self] rate in
            OperationQueue.main.addOperation {
                self.rateTextField.text = rate
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
        switch self.mode {
        case .new:
            let saveBarButtonItem: UIBarButtonItem
            let selector = #selector(saveButtonDidTap)
            saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
        case .edit:
            self.navigationItem.title = "통화 수정"
            codeTextField?.text = originCurrency.code
            rateTextField?.text = String(originCurrency.rate)
            
            let editBarButtonItem: UIBarButtonItem
            let selector = #selector(editButtonDidTap)
            editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = editBarButtonItem
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
            button.setTitle("통화 삭제", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.setTitleColor(UIColor.red.withAlphaComponent(0.3) , for: .highlighted)
            
            let buttonX = view.frame.width / 2
            let buttonY = view.frame.height / 2
            button.center = CGPoint(x: buttonX, y: buttonY)
            button.addTarget(self, action: #selector(deleteCurrencyDidTap), for: .touchUpInside)
            self.view.addSubview(button)
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
                print("통화 수정")
            }
        } catch {
            print(error)
        }
    }
    
    func currentyFromUI(currency: inout Currency) {
        
        guard let code = codeTextField?.text,
            let rateText = rateTextField.text,
            let rate = Double(rateText)
        else {
            print("fail to get currency from UI")
            return
        }
        
        currency.code = code
        currency.rate = rate
    }
    
    func deleteCurrencyDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        try! realm.write {
            self.realm.delete(originCurrency)
        }
    }
}

