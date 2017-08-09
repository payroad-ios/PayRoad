//
//  ExtensionUITextField.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 9..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UITextField {
    func inputDatePicker() {
        let pickerView: UIDatePicker = {
            let pickerView = UIDatePicker()
            pickerView.datePickerMode = .date
            pickerView.locale = Locale(identifier: "ko_KR")
            return pickerView
        }()
        
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
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY년 MM월 dd일"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter
        }()
        
        guard let targetTextField = sender.target as? UITextField,
            let inputDatePicker = targetTextField.inputView as? UIDatePicker else { return }
        targetTextField.text = dateFormatter.string(from: inputDatePicker.date)
        endEditing(true)
    }
}
