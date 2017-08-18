//
//  AddTransactionViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

enum Mode {
    case new
    case edit
}

class TransactionEditorViewController: UIViewController, UITextFieldDelegate {
    
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
    
    //User Input Data
    var standardDate: DateInRegion? = nil
    var inputCategory: CategoryTEST? = nil
    var inputImages: [UIImage]? = nil
    var isCash = true {
        didSet {
            payTypeToggleButton.isSelected = !isCash
        }
    }
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var transactionImageView: UIImageView!
    @IBOutlet weak var payTypeToggleButton: UIButton!
    @IBOutlet weak var dateEditTextField: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionViewBG: UIView!
    
    override func loadView() {
        super.loadView()
        nameTextField.addUnderline(color: ColorStore.placeHolderGray, borderWidth: 0.5)
        contentTextView.addUnderline(color: ColorStore.placeHolderGray, borderWidth: 0.5)
        dateEditTextField.addUnderline(color: ColorStore.placeHolderGray, borderWidth: 0.5)
        payTypeToggleButton.backgroundColor = ColorStore.mainSkyBlue
        payTypeToggleButton.layer.cornerRadius = payTypeToggleButton.frame.height / 3
        payTypeToggleButton.setTitleColor(payTypeToggleButton.currentTitleColor.withAlphaComponent(0.8), for: .highlighted)
        payTypeToggleButton.setTitle("현금", for: .normal)
        payTypeToggleButton.setTitle("카드", for: .selected)
        
        currencyTextField.borderStyle = .none
        categoryCollectionViewBG.addUnderline(color: ColorStore.unselectGray, borderWidth: 0.5)
        categoryCollectionViewBG.addUpperline(color: ColorStore.unselectGray, borderWidth: 0.5)
        dateEditTextField.text = DateFormatter.string(for: standardDate?.date ?? Date(), timeZone: standardDate?.timeZone)
        dateEditTextField.inputDatePicker(mode: .dateAndTime, date: standardDate?.date, timeZone: standardDate?.timeZone)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.showsHorizontalScrollIndicator = false
        
        let nibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(nibCell, forCellWithReuseIdentifier: "categoryCell")
        
        payTypeToggleButton.addTarget(self, action: #selector(togglePayTypeButtonDidTap(_:)), for: .touchUpInside)

        setupCurrencyPicker()
        self.adjustViewMode()
    }
    
    func setupCurrencyPicker() {
        //TODO: PickerView 없애면서 들어내야될 코드
        if travel.currencies.count == 1 {
            currency = travel.currencies.first!
            currencyTextField.text = currency.code
        }
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)
        
        currencyTextField.inputAccessoryView = toolbar
        currencyTextField.inputView = pickerView
    }
    
    func togglePayTypeButtonDidTap(_ sender: UIButton) {
        isCash = !isCash
        print("\(isCash ? "현금" : "카드") 선택됨")
    }

    func pickerDonePressed() {
        self.view.endEditing(true)
    }

    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkIsExistInputField() -> Bool {
        guard !(amountTextField.text!.isEmpty) else {
            UIAlertController.oneButtonAlert(target: self, title: "에러", message: "사용 금액을 입력해주세요.")
            return false
        }
        
        guard !(currency == nil) else {
            UIAlertController.oneButtonAlert(target: self, title: "에러", message: "화폐를 선택해주세요.")
            return false
        }
        
        guard !(nameTextField.text!.isEmpty) else {
            UIAlertController.oneButtonAlert(target: self, title: "에러", message: "항목명을 입력해주세요.")
            return false
        }
        return true
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
            saveBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
            
        case .edit:
            self.navigationItem.title = "항목 수정"
            nameTextField?.text = originTransaction.name
            amountTextField?.text = String(originTransaction.amount)
            currencyTextField?.text = originTransaction.currency?.code
            contentTextView.text = originTransaction.content
            isCash = originTransaction.isCash
            
            if let photoURL = originTransaction.photos.first?.fileURL,
                let image = FileUtil.loadImageFromDocumentDir(filePath: photoURL) {
                transactionImageView.image = image
            }
            
            let editBarButtonItem: UIBarButtonItem
            let selector = #selector(editButtonDidTap)
            editBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = editBarButtonItem
        }
    }
    
    func saveButtonDidTap() {
        if checkIsExistInputField() {
            var transaction = Transaction()
            transactionFromUI(transaction: &transaction)
            
            if let image = transactionImageView.image {
                let photo = FileUtil.saveNewImage(image: image)
                transaction.photos.append(photo)
            }
            
            do {
                try realm.write {
                    travel.transactions.append(transaction)
                    print("트랜젝션 추가")
                }
            } catch {
                // Alert 위해 남겨둠
                print(error)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func editButtonDidTap() {
        if checkIsExistInputField() {
            var transaction = Transaction()
            transactionFromUI(transaction: &transaction)
            
            let urlString = UUID().uuidString
            
            //image 부분 수정 필요
            if let image = transactionImageView.image {
                FileUtil.saveImageToDocumentDir(image, filePath: "\(urlString).jpg")
            }
            
            do {
                try realm.write {
                    originTransaction.name = transaction.name
                    originTransaction.amount = transaction.amount
                    originTransaction.currency = transaction.currency
                    originTransaction.content = transaction.content
                    originTransaction.isCash = transaction.isCash
                    originTransaction.dateInRegion = transaction.dateInRegion
                    
                    let urlString = UUID().uuidString
                    
                    if let image = transactionImageView.image {
                        FileUtil.saveImageToDocumentDir(image, filePath: "\(urlString).jpg")
                        originTransaction.photos.first?.id = urlString
                        originTransaction.photos.first?.fileType = "jpg"
                    }
                    print("트랜젝션 수정")
                }
            } catch {
                print(error)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func transactionFromUI(transaction: inout Transaction) {
        
        guard let name = nameTextField.text,
            let content = contentTextView.text,
            let amountText = amountTextField.text,
            let amount = Double(amountText)
        else {
            print("fail to get transaction from UI")
            return
        }
        
        let datePicker = dateEditTextField.inputView as! UIDatePicker
        let dateInRegion = DateInRegion()
        dateInRegion.date = datePicker.date
        dateInRegion.timeZone = standardDate?.timeZone ?? .current
        
        transaction.name = name
        transaction.amount = amount
        transaction.content = content
        transaction.currency = currency
        transaction.isCash = isCash
        transaction.dateInRegion = dateInRegion
    }
}



extension TransactionEditorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = CategoryStore.shard.categorys[indexPath.row]
        cell.categoryImage.image = category.image
        cell.categoryName.text = category.name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryStore.shard.categorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: 선택한 카테고리 반영
        print(CategoryStore.shard.categorys[indexPath.row].name)
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
