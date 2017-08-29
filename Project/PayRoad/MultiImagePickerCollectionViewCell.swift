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
    
    let blackLayerView: UIView = {
        let layerView = UIView()
        layerView.backgroundColor = UIColor.black
        layerView.translatesAutoresizingMaskIntoConstraints = false
        return layerView
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = ColorStore.mainSkyBlue
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
    
    func covertString() -> String? {
        return countLabel.text == "1" ? "대표" : countLabel.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            indicateForStatus()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        countLabel.text = covertString()
    }
    
    func indicateForStatus() {
        layer.borderWidth = isSelected ? 5 : 0
        blackLayerView.alpha = isSelected ? 0.3 : 0
        countLabel.isHidden = isSelected ? false : true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        blackLayerView.alpha = 0
        countLabel.text = nil
        countLabel.isHidden = true
        layer.borderWidth = 0
    }
    
    func setupViews() {
        let margin: CGFloat = 3
        backgroundColor = ColorStore.unselectGray
        addSubview(photoImageView)
        addSubview(blackLayerView)
        addSubview(countLabel)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        blackLayerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blackLayerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blackLayerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        blackLayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        layer.borderColor = ColorStore.mainSkyBlue.cgColor
        countLabel.font = countLabel.font.withSize(12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("required coder Init")
    }
}
