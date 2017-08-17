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
    var isModifyPhoto = false
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var setupCurrencyBudgetButton: UIButton!
    @IBOutlet weak var travelPreview: TravelView!
    @IBOutlet weak var deleteTravelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCurrencyBudgetButton.layer.cornerRadius = setupCurrencyBudgetButton.frame.height / 5
        deleteTravelButton.layer.cornerRadius = deleteTravelButton.frame.height / 5

        startDateTextField.inputDatePicker(mode: .date, date: originTravel?.starteDate)
        endDateTextField.inputDatePicker(mode: .date, date: originTravel?.endDate)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let travelPreviewTapGuesture = UITapGestureRecognizer()
        travelPreviewTapGuesture.addTarget(self, action: #selector(presentImagePicker))
        travelPreview.addGestureRecognizer(travelPreviewTapGuesture)
        
        adjustViewMode()
        
        titleTextField.addTarget(self, action: #selector(nameTextApply(_:)), for: .editingChanged)
        startDateTextField.addTarget(self, action: #selector(startDateTextApply(_:)), for: .editingDidEnd)
        endDateTextField.addTarget(self, action: #selector(endDateTextApply(_:)), for: .editingDidEnd)
    }
    
    
    func nameTextApply(_ sender: UITextField) {
        travelPreview.travelNameLabel.text = sender.text
    }
    
    func startDateTextApply(_ sender: UITextField) {
        let datePicker = sender.inputView as! UIDatePicker
        travelPreview.fillDatePeriodLabel(startDate: datePicker.date)
    }
    
    func endDateTextApply(_ sender: UITextField) {
        let datePicker = sender.inputView as! UIDatePicker
        travelPreview.fillDatePeriodLabel(endDate: datePicker.date)
    }
    
    func presentImagePicker(_ sender: UITapGestureRecognizer) {
        presentSelectImagePickerActionSheet()
    }
    
    @IBAction func setupCurrencyBudgetButtonDidTap(_ sender: Any) {
        let currencyTableViewStoryboard = UIStoryboard.loadViewController(from: .CurrencyTableView, ID: "CurrencyTableViewController") as! CurrencyTableViewController
        let navigationController = UINavigationController(rootViewController: currencyTableViewStoryboard)
        
//        currencyTableViewStoryboard.travel = 
//        present(navigationController, animated: true, completion: nil)
    }
    
    func presentSelectImagePickerActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAlbumAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [unowned self] (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "직접 촬영", style: .default) { [unowned self] (_) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(photoAlbumAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
            
            deleteTravelButton.isHidden = true
            
        case .edit:
            self.navigationItem.title = self.originTravel?.name
            
            let editBarButtonItem: UIBarButtonItem
            let selector = #selector(editButtonDidTap)
            editBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: selector)
            self.navigationItem.rightBarButtonItem = editBarButtonItem
            
            deleteTravelButton.isHidden = false
            
            guard let startDate = originTravel?.starteDate,
                let endDate = originTravel?.endDate
            else {
                return
            }
            
            
            titleTextField?.text = originTravel?.name
            startDateTextField?.text = DateUtil.dateFormatter.string(from: startDate)
            endDateTextField?.text = DateUtil.dateFormatter.string(from: endDate)
            
            travelPreview.travelNameLabel.text = originTravel?.name
            travelPreview.fillDatePeriodLabel(startDate: startDate, endDate: endDate)
            
            
            if let fileURL = originTravel.photo?.fileURL {
                travelPreview.backgroundImage.image = FileUtil.loadImageFromDocumentDir(filePath: fileURL)
            }
            
            deleteTravelButton.addTarget(self, action: #selector(deleteTravelButtonDidTap), for: .touchUpInside)
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
        
        if isModifyPhoto {
            guard let image = travelPreview.backgroundImage.image else { return }
            let photo = FileUtil.saveNewImage(image: image)
            travel.photo = photo
            
            //TODO: 기존 저장된 photo 삭제 메서드 추가
        }
        
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


extension TravelEditorViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        travelPreview.backgroundImage.image = image
        isModifyPhoto = true
        print(isModifyPhoto)
        dismiss(animated: true, completion: nil)
    }
}

