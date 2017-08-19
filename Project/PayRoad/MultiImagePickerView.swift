//
//  MultiImagePickerView.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 19..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

@IBDesignable class MultiImagePickerView: UIView, MultiImagePickerDelegate {
    
    let multiImagePickerCollectionViewController = MultiImagePickerCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    var delegate: UIViewController!
    let spaceSize: CGFloat = 5
    var visibleImages = [UIImage]()
    
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
        multiImagePickerCollectionViewController.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func multiImagePicker(selectedImages: [UIImage]) {
        visibleImages = selectedImages
        collectionView.reloadData()
    }
    
    @IBAction func tempPresentPickerButton(_ sender: Any) {
        
        let navigationController = UINavigationController(rootViewController: multiImagePickerCollectionViewController)
        delegate.present(navigationController, animated: true, completion: nil)
    }
    
    private func setUpView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        addSubview(view)
    }
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}



extension MultiImagePickerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectedImageCollectionViewCell
        
        cell.photoImageView.image = visibleImages[indexPath.row]
        
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
        let size = (frame.width / 6) - 1
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spaceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spaceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spaceSize, left: spaceSize, bottom: spaceSize, right: spaceSize)
    }
}
