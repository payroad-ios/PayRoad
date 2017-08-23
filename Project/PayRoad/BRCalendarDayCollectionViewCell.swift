//
//  BRCalendarDayCollectionViewCell.swift
//  PayRoad_CalendarPractice
//
//  Created by Febrix on 2017. 8. 12..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class BRCalendarDayCollectionViewCell: UICollectionViewCell {
    var fontColor = UIColor()
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var backgroundCustomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width / 3
    }
    
    func indicatorNotEqualCurrentMonth(bool: Bool) {
        dayLabel.textColor = bool ? UIColor.black : UIColor.lightGray
        fontColor = dayLabel.textColor
    }
    
    func indicatorToday(bool: Bool) {
//        self.layer.borderColor = bool ? UIColor.blue.cgColor : UIColor.clear.cgColor
//        self.layer.borderWidth = bool ? 0.5 : 0
        dayLabel.textColor = bool ? ColorStore.pastelRed : fontColor
    }
    
    override var isSelected: Bool {
        didSet {
            let skyBlue = UIColor(red: 144/255, green: 200/255, blue: 255/255, alpha: 0.7)
            self.layer.backgroundColor = isSelected ? skyBlue.cgColor : UIColor.clear.cgColor
        }
    }
}
