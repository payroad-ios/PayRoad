//
//  TransactionMapMarkerView.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 23..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class TransactionMapMarkerView: UIView {
    
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createMarker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createMarker()
    }

    func createMarker() {
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
    }
    
    func setTextLabel(text: String) {
        self.textLabel.text = text
        self.frame.size.width += textLabel.intrinsicContentSize.width
        self.frame.size.height += textLabel.intrinsicContentSize.height
    }
}
