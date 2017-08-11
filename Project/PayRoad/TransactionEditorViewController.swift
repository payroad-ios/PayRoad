//
//  AddTransactionViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class TransactionEditorViewController: UIViewController {
    
    enum Mode {
        case new
        case edit
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    
    let realm = try! Realm()
    
    var travel: Travel!
    var currency: Currency!
    var originTransaction: Transaction!
    
    var mode: Mode = .new
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: PickerView 없애면서 들어내야될 코드
        if travel.currencies.count == 1 {
            currency = travel.currencies.first!
            currencyTextField.text = currency.code
        }
        
        currencyTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)
        
        currencyTextField.inputAccessoryView = toolbar
        currencyTextField.inputView = pickerView
        
        self.adjustViewMode()
    }

    func pickerDonePressed() {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension TransactionEditorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return travel.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return travel.currencies[row].code
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currency = travel.currencies[row]
        currencyTextField.text = currency.code
    }
}

extension TransactionEditorViewController {
    fileprivate func adjustViewMode() {
        switch self.mode {
        case .new:
            let saveBarButtonItem: UIBarButtonItem
            let selector = #selector(saveButtonDidTap)
            saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
        case .edit:
            self.navigationItem.title = "항목 수정"
            nameTextField?.text = originTransaction.name
            amountTextField?.text = String(originTransaction.amount)
            currencyTextField?.text = originTransaction.currency?.code
            
            let editBarButtonItem: UIBarButtonItem
            let selector = #selector(editButtonDidTap)
            editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = editBarButtonItem
        }
    }
    
    func saveButtonDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        var transaction = Transaction()
        transactionFromUI(transaction: &transaction)
        
        let date = Date()
        transaction.date = date
        
        do {
            try realm.write {
                travel.transactions.append(transaction)
                print("트랜젝션 추가")
            }
        } catch {
            // Alert 위해 남겨둠
            print(error)
        }
    }
    
    func editButtonDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        var transaction = Transaction()
        transactionFromUI(transaction: &transaction)
        
        do {
            try realm.write {
                originTransaction.name = transaction.name
                originTransaction.amount = transaction.amount
                originTransaction.currency = transaction.currency
                print("트랜젝션 수정")
            }
        } catch {
            print(error)
        }
    }
    
    func transactionFromUI(transaction: inout Transaction) {
        
        guard let name = nameTextField.text,
            let amountText = amountTextField.text,
            let amount = Double(amountText)
        else {
            print("fail to get transaction from UI")
            return
        }
        
        transaction.name = name
        transaction.amount = amount
        transaction.currency = currency
    }
}
