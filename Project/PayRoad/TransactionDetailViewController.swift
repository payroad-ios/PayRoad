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
    lazy var photoDetailViewController: PhotoDetailViewController = {
        let photoDetailVC = UIStoryboard.loadViewController(from: .PhotoDetailView, ID: "PhotoDetailView") as! PhotoDetailViewController
        photoDetailVC.delegate = self
        photoDetailVC.modalPresentationStyle = .overCurrentContext
        photoDetailVC.modalTransitionStyle = .crossDissolve
        photoDetailVC.photos = self.transaction.photos.map { $0 }
        return photoDetailVC
    }()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountOriginCurrencyLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var payTypeImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoPageControl: UIPageControl!
    @IBOutlet weak var emptyImageView: UIImageView!
    
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addUnderline(color: ColorStore.lightGray, borderWidth: 0.5)
        descView.addUnderline(color: ColorStore.lightGray, borderWidth: 0.5)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = ColorStore.lightestGray
        
        descTextView.isEditable = false
        descTextView.backgroundColor = ColorStore.lightestGray
        
        let nibCell = UINib(nibName: "TransactionDetailCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "transactionCollectionViewCell")
        
        applyUIFromTransaction()
        
        mapView.delegate = self
        createMapView()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTransactionTableView"), object: self.transaction.id)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyUIFromTransaction), name: NSNotification.Name(rawValue: "didSavedPhoto"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        mapView.layer.cornerRadius = 8
    }
    
    func applyUIFromTransaction() {
        title = transaction.name
        
        if let assetName = transaction.category?.assetName {
            categoryImageView.image = UIImage(named: assetName)?.withRenderingMode(.alwaysTemplate)
        }
        
        guard let code = transaction.travel.first?.currencies.first?.code,
            let rate = transaction.currency?.rate else {
            return
        }
        
        dateLabel.text = transaction.dateInRegion?.string()
        titleLabel.text = transaction.name
        payTypeImageView.image = transaction.paymentImage()
        amountLabel.text = transaction.stringAmountWithCode(order: .first)
        amountOriginCurrencyLabel.text = "\(code) \((rate * transaction.amount).nonZeroString(maxDecimalPlace: 2, option: .seperator))"
        
        descTextView.placeholder = transaction.content.isEmpty ? "기록된 내용이 없습니다." : nil
        descTextView.text = transaction.content
        imageViewConstraint.constant = transaction.photos.isEmpty ? 0 : 190
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

extension TransactionDetailViewController: PhotoDatailViewDelegate {
    func changedCurrentPhoto(_ page: Int) {
        let indexPath = IndexPath(row: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoDetailViewController.selectedIndex = indexPath.row
        present(photoDetailViewController, animated: true, completion: nil)
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
        self.transaction = transaction
        applyUIFromTransaction()
        collectionView.reloadData()
    }
}

extension TransactionDetailViewController: GMSMapViewDelegate {
}
