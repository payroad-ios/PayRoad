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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startDateTextField.inputDatePicker()
        endDateTextField.inputDatePicker()
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        let travel = Travel()
        
        travel.name = titleTextField.text!
        travel.starteDate = (startDateTextField.inputView as? UIDatePicker)!.date
        travel.endDate = (endDateTextField.inputView as? UIDatePicker)!.date
        
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


