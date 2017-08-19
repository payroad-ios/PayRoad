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
}
    
class MultiImagePickerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let spaceSize: CGFloat = 2
    let cellID = "Cell"
    var delegate: MultiImagePickerDelegate?
    
    var selectedImage = [Int: UIImage]()
    var userPhotoAlbum =  UserPhotoAlbum()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPhotoAuthorization()
        setupView()
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.allowsMultipleSelection = true
        collectionView!.register(MultiImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
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
    
    func cancelButtonDidTap() {
        print("취소")
        dismiss(animated: true, completion: nil)
    }
    
    func confirmButtonDidTap() {
        let selectedArray = Array(selectedImage.values)
        delegate?.multiImagePicker(selectedImages: selectedArray)
        
        print("확인")
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
        
        userPhotoAlbum.requestImage(at: indexPath.row) { (image) in
            cell.photoImageView.image = image
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !(collectionView.indexPathsForSelectedItems!.count > 5) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            //TODO: 5개 초과 AlertController 추가
            return
        }
        
        userPhotoAlbum.requestImage(at: indexPath.row) { (image) in
            self.selectedImage[indexPath.row] = image
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedImage.removeValue(forKey: indexPath.row)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width / 3) - (spaceSize + 1)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spaceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spaceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spaceSize, left: spaceSize, bottom: spaceSize, right: spaceSize)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

