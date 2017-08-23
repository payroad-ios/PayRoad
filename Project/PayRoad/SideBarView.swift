//
//  PayRoadSideBarView.swift
//  PayRoad
//
//  Created by Yoo Seok Kim on 2017. 8. 18..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class SideBarView: UIView {
    @IBOutlet weak var goMainButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func hideSideBar(_ sender: Any) {
        guard let navigationController = UIApplication.shared.windows.first!.rootViewController as? UINavigationController else {
            return
        }
        hide() {
            navigationController.viewControllers.first?.view.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func gotoMainView() {
        guard let navigationController = UIApplication.shared.windows.first!.rootViewController as? UINavigationController else {
            return
        }
        
        hide() {
            navigationController.popToRootViewController(animated: true)
            navigationController.viewControllers.first?.view.isUserInteractionEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#function)
        self.isUserInteractionEnabled = false
        self.frame = self.defaultCGRect()
        
        goMainButton.cornerRound(cornerOptions: .allCorners, cornerRadius: 5)
        
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        
        self.layer.shadowColor = ColorStore.darkGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 7
    }

    func show(completion: (() -> Void)? = nil) {
//        UIApplication.shared.keyWindow?.windowLevel = (UIWindowLevelStatusBar + 1)
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.backgroundView.alpha = 0.3
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
            self.frame =  self.defaultCGRect()
            self.backgroundView.alpha = 0
        }, completion: { (result) in
//            UIApplication.shared.keyWindow?.windowLevel = (UIWindowLevelStatusBar - 1)
            self.isUserInteractionEnabled = false
            
            guard result == true,
                let unwrappedCompletion = completion
            else {
                return
            }
            
            unwrappedCompletion()
        })
    }
    
//    func setUpView() {
//        self.isUserInteractionEnabled = false
//        self.frame = self.defaultCGRect()
//        
//        goMainButton.cornerRound(cornerOptions: .allCorners, cornerRadius: 5)
//        
//        self.layer.shadowColor = ColorStore.darkGray.cgColor
//        self.layer.shadowOpacity = 0.8
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = 7
//    }
    
    func defaultCGRect() -> CGRect {
        return CGRect(x: -self.frame.width / 2 - 50,
                      y: 0,
                      width: self.frame.width,
                      height: self.frame.height)
    }
}
