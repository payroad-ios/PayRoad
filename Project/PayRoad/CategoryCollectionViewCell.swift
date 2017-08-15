//
//  CategoryCollectionViewCell.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 16..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.lightGray
        
        categoryImage.layer.cornerRadius = categoryImage.frame.height / 4
        categoryImage.layer.borderColor = ColorStore.unselectGray.cgColor
        categoryImage.layer.borderWidth = 1

    }
}
