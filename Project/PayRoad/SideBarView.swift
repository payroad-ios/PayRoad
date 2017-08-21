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
    
    func show(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
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
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.frame =  self.defaultCGRect()
        }, completion: { (result) in
            self.isUserInteractionEnabled = false
            
            guard result == true,
                let unwrappedCompletion = completion
            else {
                return
            }
            
            unwrappedCompletion()
        })
    }
    
    func setUpView() {
        self.isUserInteractionEnabled = false
        self.frame = self.defaultCGRect()
        
        goMainButton.cornerRound(cornerOptions: .allCorners, cornerRadius: 10)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
    }
    
    func defaultCGRect() -> CGRect {
        return CGRect(x: -self.frame.width / 2 - 20,
                      y: 0,
                      width: self.frame.width,
                      height: self.frame.height)
    }
}
