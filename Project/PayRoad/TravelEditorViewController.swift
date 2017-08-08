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
    let pickerView1: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .date
        pickerView.locale = Locale(identifier: "ko_KR")
        return pickerView
    }()
    
    let pickerView2: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .date
        pickerView.locale = Locale(identifier: "ko_KR")
        return pickerView
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }()
    
    let realm = try! Realm()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar1 = UIToolbar()
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDatePickerDonePressed))
        toolbar1.sizeToFit()
        toolbar1.setItems([doneButton1], animated: false)
        
        startDateTextField.inputAccessoryView = toolbar1
        startDateTextField.inputView = pickerView1
        
        let toolbar2 = UIToolbar()
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDatePickerDonePressed))
        toolbar2.sizeToFit()
        toolbar2.setItems([doneButton2], animated: false)
        
        endDateTextField.inputAccessoryView = toolbar2
        endDateTextField.inputView = pickerView2
    }
    
    
    //TODO: DatePicker 코드 중복 문제 해결과제
    func startDatePickerDonePressed() {
        let selectedYear = pickerView1.date
        startDateTextField.text = dateFormatter.string(from: selectedYear)
        self.view.endEditing(true)
    }
    
    func endDatePickerDonePressed() {
        let selectedYear = pickerView2.date
        endDateTextField.text = dateFormatter.string(from: selectedYear)
        self.view.endEditing(true)
    }
    @IBAction func saveButtonDidTap(_ sender: Any) {
        let travel = Travel()
        
        travel.name = titleTextField.text!
        travel.starteDate = pickerView1.date
        travel.endDate = pickerView2.date
        
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
