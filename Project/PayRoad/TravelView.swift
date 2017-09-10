//
//  TravelView.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 16..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

@IBDesignable class TravelView: UIView {
    fileprivate(set) var startDateString = ""
    fileprivate(set) var endDateString = ""
    
    @IBOutlet weak var blackLayerView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var travelNameLabel: CustomLabel!
    @IBOutlet weak var travelPeriodLabel: CustomLabel!
    @IBOutlet weak var spendingAmountLabel: CustomLabel!
    @IBOutlet weak var separateStrokeView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        addSubview(view)
    }
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func fillDatePeriodLabel(startDate: Date? = nil, endDate: Date? = nil) {
        let format = "yyyy/MM/dd"
        if let start = startDate {
            startDateString = DateFormatter.string(format: format, for: start)
        }
        if let end = endDate {
            endDateString = DateFormatter.string(format: format, for: end)
        }
        
        travelPeriodLabel.text = "\(startDateString) ~ \(endDateString)"
    }
}
