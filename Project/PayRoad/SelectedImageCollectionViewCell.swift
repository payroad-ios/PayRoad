//
//  SelectedImageCollectionViewCell.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 19..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class SelectedImageCollectionViewCell: UICollectionViewCell {
    fileprivate(set) lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate(set) lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorStore.lightestGray.withAlphaComponent(0.8)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "Icon_Margin-Cancel"), for: .normal)
        button.tintColor = UIColor.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        clipsToBounds = true
        layer.cornerRadius = frame.height / 20
        layer.borderColor = ColorStore.unselectGray.withAlphaComponent(0.8).cgColor
        layer.borderWidth = 0.8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
    }
    
    func setupViews() {
        let margin: CGFloat = 3
        backgroundColor = ColorStore.unselectGray
        addSubview(photoImageView)
        addSubview(deleteButton)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        layer.borderColor = UIColor.yellow.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("required coder Init")
    }
}
