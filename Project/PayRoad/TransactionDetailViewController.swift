//
//  TransactionDetailViewController.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 23..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift
import GoogleMaps

class TransactionDetailViewController: UIViewController {
    
    let realm = try! Realm()
    
    var transaction: Transaction!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var payTypeImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var payContentStackView: UIStackView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var photoPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = ColorStore.lightestGray
        
        descTextView.isEditable = false
        descTextView.backgroundColor = ColorStore.lightestGray
        
        payContentStackView.addUpperline(color: ColorStore.lightGray, borderWidth: 0.5)
        payContentStackView.addUnderline(color: ColorStore.lightGray, borderWidth: 0.5)
        
        let nibCell = UINib(nibName: "TransactionDetailCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "transactionCollectionViewCell")
        
        applyUIFromTransaction(transaction: transaction)
        
        mapView.delegate = self
        createMapView()
    }
    
    func createMapView() {
        guard let position = transaction.coordinate else {
            mapView.isHidden = true
            return
        }
            
        let marker = TransactionGMSMarker()
        marker.position = position
        marker.transaction = transaction
        marker.title = transaction.name
        marker.snippet = "\(transaction.amount) \(transaction.currency!.code)"
        marker.map = mapView
        
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17)
        mapView.camera = camera
    }
    
    func applyUIFromTransaction(transaction: Transaction) {
        title = transaction.name
        
        if let assetName = transaction.category?.assetName {
            categoryImageView.image = UIImage(named: assetName)
        }
        
        payTypeImageView.image = transaction.paymentImage()
        
        amountLabel.text = "\(transaction.currency?.code ?? "") \(transaction.amount.nonZeroString(maxDecimalPlace: 2, option: .seperator))"
        descTextView.text = transaction.content
    }
    
    @IBAction func editorButtonDidTap(_ sender: Any) {
        let moreOptionAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let transactionEdit = UIAlertAction(title: "지출 수정", style: .default) { [unowned self] _ in
            let transactionEditorViewController = UIStoryboard.loadViewController(from: .TransactionEditorView, ID: "TransactionEditorViewController") as! TransactionEditorViewController
            
            transactionEditorViewController.transaction = self.transaction
            transactionEditorViewController.travel = self.transaction.travel.first!
            transactionEditorViewController.editorMode = .edit
            transactionEditorViewController.standardDate = self.transaction.dateInRegion
            
            transactionEditorViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: transactionEditorViewController)
            
            self.present(navigationController, animated: true, completion: nil)
        }
        
        let transactionDelete = UIAlertAction(title: "지출 삭제", style: .destructive) { [unowned self] _ in
            
            try! self.realm.write {
                self.realm.delete(self.transaction)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        moreOptionAlertController.addAction(transactionEdit)
        moreOptionAlertController.addAction(transactionDelete)
        moreOptionAlertController.addAction(cancel)
        present(moreOptionAlertController, animated: true, completion: nil)
    }
}

//MARK:- DateSelect CollectionView Delegate, DataSource

extension TransactionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoPageControl.numberOfPages = transaction.photos.count
        return transaction.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transactionCollectionViewCell", for: indexPath) as! TransactionDetailCollectionViewCell
        
        if let image = transaction.photos[indexPath.row].fetchPhoto() {
            cell.transactionPhotoImageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.photoPageControl.currentPage = indexPath.row
    }
}

extension TransactionDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK:- TransactionEditorDelegate

extension TransactionDetailViewController: TransactionEditorDelegate {
    func edited(transaction: Transaction) {
        applyUIFromTransaction(transaction: transaction)
        collectionView.reloadData()
    }
}

extension TransactionDetailViewController: GMSMapViewDelegate {
}
