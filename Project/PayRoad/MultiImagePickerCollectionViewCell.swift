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
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = ColorStore.destructiveRed
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
    
    override func layoutSubviews() {
        countLabel.text = countLabel.text == "1" ? "대표" : countLabel.text
        countLabel.font = countLabel.font.withSize(12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 5 : 0
            countLabel.isHidden = isSelected ? false : true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    
    func setupViews() {
        let margin: CGFloat = 3
        backgroundColor = ColorStore.unselectGray
        addSubview(photoImageView)
        addSubview(countLabel)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        layer.borderColor = ColorStore.destructiveRed.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("required coder Init")
    }
}
