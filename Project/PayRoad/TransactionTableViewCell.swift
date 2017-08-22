//
//  TransactionCell.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 17..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        print(#function, self.frame)
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
        thumbnailImageView.layer.borderColor = ColorStore.lightGray.cgColor
        thumbnailImageView.layer.borderWidth = 0.5
        thumbnailImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#function, thumbnailImageView.frame)
    }
}
