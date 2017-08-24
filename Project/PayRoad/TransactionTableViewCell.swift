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
    @IBOutlet weak var paymentImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = #imageLiteral(resourceName: "Icon_ImageDefault")
        categoryImageView.image = #imageLiteral(resourceName: "Category_Etc")
        paymentImageView.image = #imageLiteral(resourceName: "Payment_Cash")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
        thumbnailImageView.layer.borderColor = ColorStore.lightGray.cgColor
        thumbnailImageView.layer.borderWidth = 0.7
        thumbnailImageView.clipsToBounds = true
        categoryImageView.tintColor = ColorStore.darkGray
        paymentImageView.tintColor = ColorStore.darkGray.withAlphaComponent(0.8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryImageView.image = categoryImageView.image!.withRenderingMode(.alwaysTemplate)
        paymentImageView.image = paymentImageView.image!.withRenderingMode(.alwaysTemplate)
    }
}
