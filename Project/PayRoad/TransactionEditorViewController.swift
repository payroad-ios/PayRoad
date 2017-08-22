//
//  AddTransactionViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class TransactionEditorViewController: UIViewController, UITextFieldDelegate {
    let realm = try! Realm()
    
    var travel: Travel!
    var currency: Currency!
    var transaction = Transaction()
    
    var editorMode: EditorMode = .new
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    //User Input Data
    var standardDate: DateInRegion? = nil
    var inputImages: [UIImage]? = nil
    var isCash = true {
        didSet {
            payTypeToggleButton.isSelected = !isCash
        }
    }
    
    var category: Category? = nil
    lazy var categories: Results<Category> = { [unowned self] in
        return self.realm.objects(Category.self)
    }()
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var payTypeToggleButton: UIButton!
    @IBOutlet weak var dateEditTextField: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionViewBG: UIView!
    @IBOutlet weak var multiImagePickerView: MultiImagePickerView!
    
    override func loadView() {
        super.loadView()
        nameTextField.addUnderline(color: ColorStore.unselectGray, borderWidth: 0.5)
        contentTextView.addUnderline(color: ColorStore.unselectGray, borderWidth: 0.5)
        dateEditTextField.addUnderline(color: ColorStore.unselectGray, borderWidth: 0.5)
        payTypeToggleButton.backgroundColor = ColorStore.mainSkyBlue
        payTypeToggleButton.layer.cornerRadius = payTypeToggleButton.frame.height / 5
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
        currencyTextField.delegate = self
        
        multiImagePickerView.delegate = self
        
        let nibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(nibCell, forCellWithReuseIdentifier: "categoryCell")
        
        payTypeToggleButton.addTarget(self, action: #selector(togglePayTypeButtonDidTap(_:)), for: .touchUpInside)

        setupCurrencyPicker()
        adjustViewMode()
    }
    
    func setupCurrencyPicker() {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([space, doneButton], animated: false)
        
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
        view.endEditing(true)
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
        let barButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: #selector(writeButtonDidTap))
        navigationItem.rightBarButtonItem = barButtonItem
        
        switch self.editorMode {
        case .new:
            
            //TODO: PickerView 없애면서 들어내야될 코드
            if let lastCurrency = travel.transactions.last?.currency {
                currency = lastCurrency
                currencyTextField.text = lastCurrency.code
            } else {
                currency = travel.currencies.first!
                currencyTextField.text = currency?.code
            }
            
            if let _category = realm.object(ofType: Category.self, forPrimaryKey: "category-etc") {
                category = _category
            }
            
        case .edit:
            self.navigationItem.title = "항목 수정"
            
            nameTextField?.text = transaction.name
            amountTextField?.text = String(transaction.amount)
            currencyTextField?.text = transaction.currency?.code
            contentTextView.text = transaction.content
            isCash = transaction.isCash
            currency = transaction.currency
            category = transaction.category
            
            if let _category = transaction.category {
                category = _category
            }
            
            var photos = [UIImage]()
            transaction.photos.forEach {
                guard let image = $0.fetchPhoto() else { return }
                photos.append(image)
            }
            multiImagePickerView.visibleImages = photos
            
        }
        let index = travel.currencies.index(of: currency)
        pickerView.selectRow(index!, inComponent: 0, animated: true)
        
        if let _category = category,
            let categoryIndex = categories.index(of: _category) {
            categoryCollectionView.selectItem(at: IndexPath(row: categoryIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
        
    }
    
    func writeButtonDidTap() {
        if checkIsExistInputField() {
            do {
                try realm.write {
                    transactionFromUI(transaction: &transaction)

                    if editorMode == .new {
                        savePhotoTransaction(target: transaction)
                        travel.transactions.append(transaction)
                        
                    } else if editorMode == .edit {
                        if multiImagePickerView.isChanged {
                            for item in transaction.photos {
                                FileUtil.removeData(filePath: item.filePath)
                                realm.delete(item)
                            }
                            savePhotoTransaction(target: transaction)
                        }
                        transaction.name = transaction.name
                        transaction.amount = transaction.amount
                        transaction.currency = transaction.currency
                        transaction.content = transaction.content
                        transaction.isCash = transaction.isCash
                        transaction.dateInRegion = transaction.dateInRegion
                        
                    // 수정 시 update를 쓰기위한 코드. append로 할 경우 수정시에도 데이터가 더해짐. 아래 코드로 사용할 경우 해결이 되나, 역관계 성립이 안되어 Travel에 종속되지 않음.
                    // 리스트에 종속시킴과 동시에 update 파라미터를 지원하는 메서드가 있으면 좋을 것.
//                    realm.add(transaction, update: true)
                    }
                    
                    print("트랜젝션 수정")
                }
                
            } catch {
                // Alert 위해 남겨둠
                print(error)
            }
            
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func savePhotoTransaction(target: Transaction) {
        multiImagePickerView.visibleImages.forEach {
            let photo = PhotoUtil.saveTransactionPhoto(travelID: travel.id, transactionID: transaction.id, photo: $0)
            target.photos.append(photo)
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
        
        transaction.name = name
        transaction.amount = amount
        transaction.currency = currency
        transaction.content = content
        transaction.isCash = isCash
        transaction.category = category
        
        if let dateInRegion = standardDate {
            dateInRegion.date = datePicker.date
            transaction.dateInRegion = dateInRegion
        } else {
            let dateInRegion = DateInRegion()
            dateInRegion.date = datePicker.date
            transaction.dateInRegion = dateInRegion
        }
    }
}

extension TransactionEditorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        
        cell.categoryImage.image = UIImage(named: category.assetName)
        cell.categoryName.text = category.name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: 선택한 카테고리 반영
        print(categories[indexPath.row].name)
        
        category = categories[indexPath.row]
    }
}


extension TransactionEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        multiImagePickerView.visibleImages.append(selectedImage)
        multiImagePickerView.collectionView.reloadData()
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
}
