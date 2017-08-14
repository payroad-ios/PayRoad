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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var transactionImageView: UIImageView!
    
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
            
            if let photoURL = originTransaction.photos.first?.fileURL,
                let image = FileUtil.loadImageFromDocumentDir(filePath: photoURL) {
                transactionImageView.image = image
            }
            
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
        
        if let image = transactionImageView.image {
            let photo = Photo()
            
            photo.id = UUID().uuidString
            photo.fileType = "jpg"
            
            FileUtil.saveImageToDocumentDir(image, filePath: photo.fileURL)
            transaction.photos.append(photo)
        }
        
        let dateInRegion = DateInRegion()
        dateInRegion.date = Date()
        dateInRegion.timeZone = TimeZone.current
        transaction.dateInRegion = dateInRegion
        
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

        let urlString = UUID().uuidString
        
        if let image = transactionImageView.image {
            FileUtil.saveImageToDocumentDir(image, filePath: "\(urlString).jpg")
        }
        
        do {
            try realm.write {
                originTransaction.name = transaction.name
                originTransaction.amount = transaction.amount
                originTransaction.currency = transaction.currency
                originTransaction.photos.first?.id = urlString
                originTransaction.photos.first?.fileType = "jpg"
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

extension TransactionEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        transactionImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let imagePickerController = UIImagePickerController()
        
        if mode == .edit,
            let photo = originTransaction.photos.first {
            FileUtil.removeImageOnDocumentDir(filePath: photo.fileURL)
            transactionImageView.image = nil
        }
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
}
