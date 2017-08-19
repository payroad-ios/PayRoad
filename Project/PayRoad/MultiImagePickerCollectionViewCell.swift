//
//  MultiImagePickerCollectionViewCell.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 19..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class MultiImagePickerCollectionViewCell: UICollectionViewCell {
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 5 : 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    
    func setupViews() {
        backgroundColor = ColorStore.unselectGray
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        layer.borderColor = UIColor.yellow.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("required coder Init")
    }
}
