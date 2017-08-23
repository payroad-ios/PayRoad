//
//  TransactionMapMarkerView.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 23..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class TransactionMapMarkerView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createMarker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createMarker()
    }


    func createMarker() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        print("marker created")
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TransactionMapMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

