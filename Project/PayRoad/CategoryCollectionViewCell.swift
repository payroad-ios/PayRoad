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
        categoryImage.tintColor = ColorStore.unselectGray
        categoryName.textColor = ColorStore.unselectGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryImage.image = categoryImage.image!.withRenderingMode(.alwaysTemplate)
    }
    
    override var isSelected: Bool {
        didSet {
            categoryImage.tintColor = isSelected ? ColorStore.basicBlack : ColorStore.unselectGray
            categoryName.textColor = isSelected ? ColorStore.basicBlack : ColorStore.unselectGray
        }
    }
}
