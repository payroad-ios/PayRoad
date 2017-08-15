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
    
    let realm = try! Realm()
    var mode: Mode = .new
    var originTravel: Travel!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startDateTextField.inputDatePicker()
        endDateTextField.inputDatePicker()
        
        self.adjustViewMode()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TravelEditorViewController {
    fileprivate func adjustViewMode() {
        switch self.mode {
        case .new:
            let saveBarButtonItem: UIBarButtonItem
            let selector = #selector(saveButtonDidTap)
            saveBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
        case .edit:
            self.navigationItem.title = self.originTravel?.name
            
            let editBarButtonItem: UIBarButtonItem
            let selector = #selector(editButtonDidTap)
            editBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = editBarButtonItem
            
            guard let startDate = originTravel?.starteDate,
                let endDate = originTravel?.endDate
            else {
                return
            }
            
            titleTextField?.text = originTravel?.name
            startDateTextField?.text = DateUtil.dateFormatter.string(from: startDate)
            endDateTextField?.text = DateUtil.dateFormatter.string(from: endDate)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
            button.setTitle("여행 삭제", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.setTitleColor(UIColor.red.withAlphaComponent(0.3) , for: .highlighted)
            
            let buttonX = view.frame.width / 2
            let buttonY = view.frame.height / 2
            button.center = CGPoint(x: buttonX, y: buttonY)
            button.addTarget(self, action: #selector(deleteTravelButtonDidTap), for: .touchUpInside)
            self.view.addSubview(button)
        }
    }
    
    func saveButtonDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        var travel = Travel()
        travelFromUI(travel: &travel)
        
        if let currencyCode = Locale.current.currencyCode {
            let currency = Currency()
            currency.code = currencyCode
            currency.rate = 1.0
            travel.currencies.append(currency)
        }
        
        try? realm.write {
            realm.add(travel)
        }
    }
    
    func editButtonDidTap() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        var travel = Travel()
        travelFromUI(travel: &travel)
        
        try! realm.write {
            originTravel?.name = travel.name
            originTravel?.starteDate = travel.starteDate
            originTravel?.endDate = travel.endDate
            
            originTravel?.startYear = travel.startYear
            originTravel?.startMonth = travel.startMonth
            originTravel?.startDay = travel.startDay
            originTravel?.endYear = travel.endYear
            originTravel?.endMonth = travel.endMonth
            originTravel?.endDay = travel.endDay
        }
    }
    
    func travelFromUI(travel: inout Travel) {
        
        guard let name = titleTextField?.text,
            let startDateText = startDateTextField?.text,
            let startDate = DateUtil.dateFormatter.date(from: startDateText),
            let endDateText = endDateTextField?.text,
            let endDate = DateUtil.dateFormatter.date(from: endDateText)
        else {
            print("fail to get travel from UI")
            return
        }
        
        travel.name = name
        travel.starteDate = startDate
        travel.endDate = endDate
        
        let calendar = Calendar.current
        travel.startYear = calendar.component(.year, from: startDate)
        travel.startMonth = calendar.component(.month, from: startDate)
        travel.startDay = calendar.component(.day, from: startDate)
        travel.endYear = calendar.component(.year, from: endDate)
        travel.endMonth = calendar.component(.month, from: endDate)
        travel.endDay = calendar.component(.day, from: endDate)
    }
    
    func deleteTravelButtonDidTap() {
        try! realm.write {
            self.realm.delete(originTravel)
        }
        
        let navigationController = presentingViewController as? UINavigationController
        self.dismiss(animated: true) {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

