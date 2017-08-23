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
    let realm = try! Realm()
    var editorMode: EditorMode = .new
    var travel = Travel()
    var isModifyPhoto = false
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    let defaultBackgroundBGArray = [#imageLiteral(resourceName: "SampleBG_Rome"), #imageLiteral(resourceName: "SampleBG_Paris"), #imageLiteral(resourceName: "SampleBG_Seoul"), #imageLiteral(resourceName: "SampleBG_Franch"), #imageLiteral(resourceName: "SampleBG_JeonJu"), #imageLiteral(resourceName: "SampleBG_London"), #imageLiteral(resourceName: "SampleBG_NewYork"), #imageLiteral(resourceName: "SampleBG_NewYork2"), #imageLiteral(resourceName: "SampleBG_HongKong")]
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var travelPreview: TravelView!
    @IBOutlet weak var deleteTravelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteTravelButton.layer.cornerRadius = deleteTravelButton.frame.height / 5

        startDateTextField.inputDatePicker(mode: .date, date: travel.startDateInRegion?.date)
        endDateTextField.inputDatePicker(mode: .date, date: travel.endDateInRegion?.date)
        
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
        
        currencyTableViewStoryboard.travel = travel
        present(navigationController, animated: true, completion: nil)
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
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func checkIsExistInputField() -> Bool {
        guard !(titleTextField.text!.isEmpty) else {
            UIAlertController.oneButtonAlert(target: self, title: "에러", message: "제목을 입력해 주세요.")
            return false
        }
        
        guard !(startDateTextField.text!.isEmpty || endDateTextField.text!.isEmpty) else {
            UIAlertController.oneButtonAlert(target: self, title: "에러", message: "기간을 지정해 주세요.")
            return false
        }
        return true
    }
}

extension TravelEditorViewController {
    fileprivate func adjustViewMode() {
        let barButtonItem: UIBarButtonItem = .init(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: #selector(writeButtonDidTap))
        navigationItem.rightBarButtonItem = barButtonItem

        switch self.editorMode {
            case .new:
                deleteTravelButton.isHidden = true
                travelPreview.backgroundImage.image = defaultBackgroundBGArray[Int(arc4random_uniform(UInt32(defaultBackgroundBGArray.count)))]
                isModifyPhoto = true
            
            case .edit:
                self.navigationItem.title = self.travel.name
                
                deleteTravelButton.isHidden = false
                isModifyPhoto = false
                titleTextField?.text = travel.name
                startDateTextField?.text = DateUtil.dateFormatter.string(from: travel.startDateInRegion!.date)
                endDateTextField?.text = DateUtil.dateFormatter.string(from: travel.endDateInRegion!.date)
                
                travelPreview.travelNameLabel.text = travel.name
                travelPreview.fillDatePeriodLabel(startDate: travel.startDateInRegion!.date, endDate: travel.endDateInRegion!.date)
                

                if let filePath = travel.photo?.filePath {
                    travelPreview.backgroundImage.image = PhotoUtil.loadPhotoFrom(filePath: filePath)
                
                deleteTravelButton.addTarget(self, action: #selector(deleteTravelButtonDidTap), for: .touchUpInside)
            }
        }
    }
    
    func writeButtonDidTap() {
        if checkIsExistInputField() {
            try? realm.write {
                travelFromUI(travel: &travel)
                realm.add(travel, update: true)
            }
            
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
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
        
        if editorMode == .new {
            travel.startDateInRegion = DateInRegion()
            travel.endDateInRegion = DateInRegion()
        }
        
        travel.name = name
        travel.startDateInRegion?.date = startDate
        travel.endDateInRegion?.date = endDate
        
//        TODO: 커버사진 저장 코드 수정 보완해야함
        if isModifyPhoto {
            if let photo = travel.photo {
                PhotoUtil.deletePhoto(filePath: photo.filePath)
                realm.delete(photo)
            }
            
            guard let image = travelPreview.backgroundImage.image else { return }
            let photo = PhotoUtil.saveCoverPhoto(travelID: travel.id, photo: image)
            travel.photo = photo
        }
    }
    
    func deleteTravelButtonDidTap() {
        UIAlertController.confirmStyleAlert(target: self, title: "여행 삭제", message: "이 여행을 정말로 삭제하시겠습니까?", buttonTitle: nil) { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTravelNotification"), object: nil, userInfo: nil)
        
            FileUtil.removeAllData(travelID: self.travel.id)
            Object.cascadingDelete(realm: self.realm, object: self.travel)
            
            let navigationController = self.presentingViewController as? UINavigationController
            self.dismiss(animated: true) {
                navigationController?.popToRootViewController(animated: true)
            }
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

