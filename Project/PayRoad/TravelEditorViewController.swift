//
//  AddTrevelViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class TravelEditorViewController: UIViewController {
    
    enum Mode {
        case new
        case edit
    }
    
    // MARK: - Properties
    var originTravel: Travel!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    let realm = try! Realm()
    
    var mode: Mode = .new {
        didSet {
            self.adjustViewMode()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startDateTextField.inputDatePicker()
        endDateTextField.inputDatePicker()
        
        guard let startDate = originTravel?.starteDate,
            let endDate = originTravel?.endDate
            else {
                return
        }
        
        titleTextField?.text = originTravel?.name
        startDateTextField?.text = DateUtil.dateFormatter.string(from: startDate)
        endDateTextField?.text = DateUtil.dateFormatter.string(from: endDate)
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        let travel = Travel()
        
        travel.name = titleTextField.text!
        travel.starteDate = (startDateTextField.inputView as? UIDatePicker)!.date
        travel.endDate = (endDateTextField.inputView as? UIDatePicker)!.date
        
        if let currencyCode = Locale.current.currencyCode {
            let currency = Currency()
            currency.code = currencyCode
            currency.rate = 1.0
            travel.currencies.append(currency)
        }
        
        try? realm.write {
            realm.add(travel)
            print("여행생성")
            dump(travel)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension TravelEditorViewController {
    fileprivate func adjustViewMode() {
        switch self.mode {
        case .new:
            break
        case .edit:
            self.navigationItem.title = self.originTravel?.name
            
            let editBarButtonItem: UIBarButtonItem
            let selector = #selector(endEdit)
            editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = editBarButtonItem
        }
    }
    
    func endEdit() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard let name = titleTextField?.text,
            let startDateText = startDateTextField?.text,
            let startDate = DateUtil.dateFormatter.date(from: startDateText),
            let endDateText = endDateTextField?.text,
            let endDate = DateUtil.dateFormatter.date(from: endDateText)
        else {
            return
        }
        
        originTravel?.name = name
        originTravel?.starteDate = startDate
        originTravel?.endDate = endDate
    }
}

