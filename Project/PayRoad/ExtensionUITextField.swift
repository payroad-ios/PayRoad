//
//  ExtensionUITextField.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 9..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UITextField {
    func inputDatePicker(mode: UIDatePickerMode, date: Date? = nil, timeZone: TimeZone? = nil) {
        let pickerView: UIDatePicker = {
            let pickerView = UIDatePicker()
            pickerView.datePickerMode = mode
            pickerView.timeZone = timeZone ?? .current
            guard let userDate = date else { return pickerView }
            pickerView.date = userDate
            return pickerView
        }()
        
        switch mode {
        case .countDownTimer:
            self.tag = 8000
        case .date:
            self.tag = 8001
        case .dateAndTime:
            self.tag = 8002
        case .time:
            self.tag = 8003
        }
        
        let toolBar: UIToolbar = {
            let toolBar = UIToolbar()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidPressed))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.sizeToFit()
            toolBar.setItems([space, doneButton], animated: false)
            return toolBar
        }()
        
        self.inputAccessoryView = toolBar
        self.inputView = pickerView
    }
    
    @objc private func doneDidPressed(_ sender: UIBarButtonItem) {
        guard let targetTextField = sender.target as? UITextField,
            let inputDatePicker = targetTextField.inputView as? UIDatePicker else { return }
        
        switch targetTextField.tag {
        case 8001:
            targetTextField.text = DateUtil.dateFormatter.string(from: inputDatePicker.date)
        case 8002:
            targetTextField.text = DateFormatter.string(for: inputDatePicker.date, timeZone: nil)
        default:
            targetTextField.text = DateFormatter().string(from: inputDatePicker.date)
        }
        endEditing(true)
    }
}
