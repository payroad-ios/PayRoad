//
//  MultiImagePickerView.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 19..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

@IBDesignable class MultiImagePickerView: UIView, MultiImagePickerDelegate {
    fileprivate let margin: CGFloat = 5
    fileprivate(set) lazy var multiImagePickerCollectionViewController = MultiImagePickerCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()
    fileprivate(set) var delegate: UIViewController!
    fileprivate(set) var visibleImages = [UIImage]()
    
    var isChanged: Bool = false
    var isTakePicture: Bool = false
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        collectionView.register(SelectedImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self

        multiImagePickerCollectionViewController.set(delegate: self)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func multiImagePicker(selectedImages: [UIImage]) {
        visibleImages = selectedImages
        collectionView.reloadData()
    }
    
    private func setUpView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        addSubview(view)
        addImageButton.layer.cornerRadius = addImageButton.frame.height / 6
        collectionView.backgroundColor = ColorStore.lightestGray
    }
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func deleteSelectedImage(_ sender: UIButton) {
        let cell = sender.superview as! SelectedImageCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        deselectImage(indexPath: indexPath)
    }
    
    func deselectImage(indexPath: IndexPath) {
        visibleImages.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        isChanged = true
        
        guard !multiImagePickerCollectionViewController.orderIndexPaths.isEmpty else {
            return
        }
        multiImagePickerCollectionViewController.removeDeselectItem(at: indexPath.row)
    }
    
    @IBAction func addImageButtonDidTap(_ sender: UIButton) {
        let selectorAlertController = UIAlertController(title: "사진 추가", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "직접 촬영", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            if !self.visibleImages.isEmpty {
                
            }
            self.delegate.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            
            func presentMultiPicker() {
                let navigationController = UINavigationController(rootViewController: self.multiImagePickerCollectionViewController)
                self.delegate.present(navigationController, animated: true, completion: nil)
            }
            
            if self.isTakePicture {
                let deleteWarningAlertController = UIAlertController(title: "경고", message: "직접 촬영한 사진은 삭제됩니다.\n계속하시겠습니까?", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                let okButton = UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
                    self.isTakePicture = false
                    self.multiImagePickerCollectionViewController.resetSelectImage()
                    presentMultiPicker()
                })
                
                deleteWarningAlertController.addAction(cancelButton)
                deleteWarningAlertController.addAction(okButton)
                self.delegate.present(deleteWarningAlertController, animated: true, completion: nil)
            } else {
                presentMultiPicker()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        selectorAlertController.addAction(cameraAction)
        selectorAlertController.addAction(photoLibraryAction)
        selectorAlertController.addAction(cancelAction)
        delegate.present(selectorAlertController, animated: true, completion: nil)
    }
}

extension MultiImagePickerView {
    func set(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func set(visibleImages: [UIImage]) {
        self.visibleImages = visibleImages
    }
    
    func appendVisibleImage(image: UIImage) {
        self.visibleImages.append(image)
    }
}

extension MultiImagePickerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectedImageCollectionViewCell
        
        cell.photoImageView.image = visibleImages[indexPath.row]
        cell.deleteButton.addTarget(self, action: #selector(deleteSelectedImage(_:)), for: .touchUpInside)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension MultiImagePickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (frame.width / 4) - 1
        return CGSize(width: size * 1.3, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
}

extension MultiImagePickerView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        multiImagePicker(selectedImages: [image])
        isTakePicture = true
        
        print("visible", visibleImages.count)
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
}
