//
//  MultiImagePickerViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 19..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

protocol MultiImagePickerDelegate {
    func multiImagePicker(selectedImages: [UIImage])
    var isChanged: Bool { get set }
}
    
class MultiImagePickerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let margin: CGFloat = 2
    let cellID = "Cell"
    var delegate: MultiImagePickerDelegate?
    var userPhotoAlbum = UserPhotoAlbum()

    var selectedImages = [[Int: UIImage]]()
    var orderIndexPaths = [IndexPath]()
    
    var restoreSelectedImages = [[Int: UIImage]]()
    var restoreOrderIndexPaths = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPhotoAuthorization()
        setupView()
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.allowsMultipleSelection = true
        collectionView!.register(MultiImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreSelectedImages = selectedImages
        restoreOrderIndexPaths = orderIndexPaths
    }
    
    func checkPhotoAuthorization() {
        userPhotoAlbum.authorization(target: self) {
            DispatchQueue.main.async {
                self.userPhotoAlbum = UserPhotoAlbum()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func setupView() {
        title = "사진앨범"
        let cancelBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_Cancel"), style: .plain, target: self, action: #selector(cancelButtonDidTap))
        let confirmBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_Check"), style: .plain, target: self, action: #selector(confirmButtonDidTap))
        navigationItem.leftBarButtonItems = [cancelBarButton]
        navigationItem.rightBarButtonItems = [confirmBarButton]
    }
    
    func drawCountCellOrder() {
        for (index, item) in orderIndexPaths.enumerated() {
            if let cell = collectionView?.cellForItem(at: item) as? MultiImagePickerCollectionViewCell {
                cell.countLabel.text = String(index + 1)
            }
        }
    }
    
    func removeDeselectItem(at index: Int) {
        let inputIndexPath = orderIndexPaths[index]
        collectionView?.deselectItem(at: inputIndexPath, animated: false)
        collectionView?.reloadItems(at: [inputIndexPath])
        
        selectedImages.remove(at: index)
        orderIndexPaths.remove(at: index)
        
        drawCountCellOrder()
    }
    
    func restorePicker() {
        for indexPath in orderIndexPaths {
            collectionView?.deselectItem(at: indexPath, animated: false)
            collectionView?.reloadItems(at: [indexPath])
        }
        
        for indexPath in restoreOrderIndexPaths {
            collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        selectedImages = restoreSelectedImages
        orderIndexPaths = restoreOrderIndexPaths
        
        drawCountCellOrder()
    }
    
    func cancelButtonDidTap() {
        restorePicker()
        dismiss(animated: true, completion: nil)
    }
    
    func confirmButtonDidTap() {
        let selectedArray = selectedImages.map { [UIImage]($0.values) }.flatMap { $0 }
        delegate?.multiImagePicker(selectedImages: selectedArray)
        delegate?.isChanged = true
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotoAlbum.count()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MultiImagePickerCollectionViewCell
        cell.indicateForStatus()
        userPhotoAlbum.requestImage(at: indexPath.row, imageSize: .thumbnail) { (image) in
            cell.photoImageView.image = image
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !(collectionView.indexPathsForSelectedItems!.count > 5) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            UIAlertController.oneButtonAlert(target: self, title: "사진 앨범", message: "사진은 최대 5장까지 선택 가능합니다.")
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! MultiImagePickerCollectionViewCell
        orderIndexPaths.append(indexPath)
        userPhotoAlbum.requestImage(at: indexPath.row, imageSize: .original) { (image) in
            let resultDictionary = [indexPath.row: image]
            self.selectedImages.append(resultDictionary)
        }
        cell.countLabel.text = String(selectedImages.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let imageIndex = selectedImages.index { [Int]($0.keys).contains(indexPath.row) }
        removeDeselectItem(at: imageIndex!)
    }    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! MultiImagePickerCollectionViewCell 
        
        if orderIndexPaths.contains(indexPath) {
            let orderIndex = orderIndexPaths.index(of: indexPath)!
            cell.countLabel.text = String(orderIndex + 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width / 3) - (margin + 1)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
}

