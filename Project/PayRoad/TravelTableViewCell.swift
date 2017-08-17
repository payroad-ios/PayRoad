//
//  TravelTableViewCell.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 16..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class TravelTableViewCell: UITableViewCell {
    @IBOutlet weak var travelView: TravelView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = travelView.blackLayerView.backgroundColor
        
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            travelView.blackLayerView.backgroundColor = color?.withAlphaComponent(0.6)
            travelView.separateStrokeView.backgroundColor = UIColor.white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = travelView.blackLayerView.backgroundColor
        
        super.setSelected(selected, animated: animated)
        if selected {
            travelView.blackLayerView.backgroundColor = color
            travelView.separateStrokeView.backgroundColor = UIColor.white
        }
    }
}
