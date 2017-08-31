//
//  PayRoadSideBarView.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 18..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class SideBarView: UIView {
    @IBOutlet weak var diaryButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var goMainButton: UIButton!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sideBarLeadingConstraint: NSLayoutConstraint!
    weak var delegate: TransactionTableViewController?
    
    @IBAction func hideSideBar(_ sender: Any) {
        hide() {
            self.delegate?.navigationController?.view.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func diaryButtonDidTap(_ sender: Any) {
        hide() {
            self.delegate?.presentDiaryView()
        }
    }
    
    @IBAction func mapButtonDidTap(_ sender: Any) {
        hide() {
            self.delegate?.presentMapView()
        }
    }
    
    @IBAction func gotoMainView() {
        hide() {
            self.delegate?.navigationController?.popToRootViewController(animated: true)
            self.delegate?.navigationController?.view.isUserInteractionEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        sideBarLeadingConstraint.constant = hideConstant()
        
        goMainButton.cornerRound(cornerOptions: .allCorners, cornerRadius: 5)
        
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        
        self.layer.shadowColor = ColorStore.darkGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 7
    }

    func show(completion: (() -> Void)? = nil) {
        UIApplication.shared.keyWindow?.windowLevel = (UIWindowLevelStatusBar + 1)
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.sideBarLeadingConstraint.constant = 0
            self.backgroundView.alpha = 0.3
            self.layoutIfNeeded()
        }, completion: { [unowned self] (result) in
            self.isUserInteractionEnabled = true
            
            guard result == true,
                let unwrappedCompletion = completion
            else {
                return
            }
            
            unwrappedCompletion()
        })
    }
    
    func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.18, animations: { [unowned self] in
            self.sideBarLeadingConstraint.constant = self.hideConstant()
            self.backgroundView.alpha = 0
            self.layoutIfNeeded()
        }, completion: { (result) in
            UIApplication.shared.keyWindow?.windowLevel = (UIWindowLevelStatusBar - 1)
            self.isUserInteractionEnabled = false
            
            guard result == true,
                let unwrappedCompletion = completion
            else {
                return
            }
            
            unwrappedCompletion()
        })
    }
    
    func hideConstant() -> CGFloat {
        return -(self.menuView.frame.width + 20)
    }
}
