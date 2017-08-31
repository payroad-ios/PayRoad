//
//  TransactionMapCollectionViewCell.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 22..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class TransactionMapCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.borderColor = ColorStore.lightGray.cgColor
        thumbnailImageView.layer.borderWidth = 0.7
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = #imageLiteral(resourceName: "Icon_ImageDefault")
    }
}
