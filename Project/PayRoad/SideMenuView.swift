//
//  SideMenuView.swift
//  PayRoad
//
//  Created by Febrix on 2018. 1. 9..
//  Copyright © 2018년 REFUEL. All rights reserved.
//

import UIKit

class SideMenuView: UIView {

    @IBOutlet weak var transactionButton: UIButton!
    @IBOutlet weak var diaryButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var goMainButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sideBarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideTapGesture: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let bounds = UIScreen.main.bounds
        self.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        setMenuConstraint(isHide: true)
        setButtonsAttribute()
        setPanGesture()
        
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        
        layer.shadowColor = ColorStore.darkGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 7
        
        goMainButton.cornerRound(cornerOptions: .allCorners, cornerRadius: 5)
        
        hideTapGesture.addTarget(self, action: #selector(hideMenu))
        diaryButton.addTarget(self, action: #selector(presentDiary), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(presentMap), for: .touchUpInside)
        goMainButton.addTarget(self, action: #selector(popToMain), for: .touchUpInside)
        
    }
    
    func setPanGesture() {
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(detectPanGesture(_:)))
        panGuesture.delegate = self
        panGuesture.maximumNumberOfTouches = 1
        menuView.addGestureRecognizer(panGuesture)
    }
    
    func setButtonsAttribute() {
        transactionButton.setTitleColor(ColorStore.darkGray, for: .normal)
        diaryButton.setTitleColor(ColorStore.unselectGray, for: .normal)
        mapButton.setTitleColor(ColorStore.unselectGray, for: .normal)
        
        transactionButton.setTitleColor(ColorStore.darkGray, for: .selected)
        diaryButton.setTitleColor(ColorStore.darkGray, for: .selected)
        mapButton.setTitleColor(ColorStore.darkGray, for: .selected)
        
        transactionButton.isSelected = true
    }
    
    func showMenu() {
        hide()
    }
    
    func hideMenu() {
        hide()
    }
    
    func presentDiary() {
        guard let transactionVC = getTransactionTableViewController() else { return }
        hide {
            transactionVC.presentDiaryView()
        }
    }
    
    func presentMap() {
        guard let transactionVC = getTransactionTableViewController() else { return }
        hide {
            transactionVC.presentMapView()
        }
    }
    
    func popToMain() {
        hide {
            let childViewController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            childViewController.popToRootViewController(animated: true)
        }
    }
    
    
    func show(completion: (() -> Void)? = nil) {
        if Device.currentDevice != .iPhoneX {
            UIApplication.shared.keyWindow?.windowLevel = (UIWindowLevelStatusBar + 1)
        }
        
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.setMenuConstraint(isHide: false)
        }, completion: { _ in
            completion?()
        })
    }
    
    func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.18, animations: { [unowned self] in
            self.setMenuConstraint(isHide: true)
        }, completion: { (result) in
            if Device.currentDevice != .iPhoneX {
                UIApplication.shared.keyWindow?.windowLevel = (UIWindowLevelStatusBar - 1)
            }
            
            self.removeFromSuperview()
            guard let completionAction = completion else { return }
            completionAction()
        })
    }
    
    func getTransactionTableViewController() -> TransactionTableViewController? {
        let childViewController = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers
        guard let travelIndex = childViewController?.index(where: { $0.restorationIdentifier == "Travel" }),
            let travelViewController = childViewController?[travelIndex] as? TransactionTableViewController else {
                return nil
        }
        return travelViewController
    }
    
    func setMenuConstraint(isHide: Bool) {
        sideBarLeadingConstraint.constant = isHide ? getHideConstant() : 0
        backgroundView.alpha = isHide ? 0 : 0.3
        layoutIfNeeded()
    }
    
    func getHideConstant() -> CGFloat {
        return -(self.menuView.frame.width + 20)
    }

}

extension SideMenuView: UIGestureRecognizerDelegate {
    func detectPanGesture(_ sender: UIPanGestureRecognizer) {
        let targetView = sender.view
        let translation = sender.translation(in: targetView)
        
        switch sender.state {
        case .changed:
            if translation.x < 1 {
                sideBarLeadingConstraint.constant = translation.x
            }
            
        case .ended:
            let velocity = sender.velocity(in: targetView)
            
            if sideBarLeadingConstraint.constant > -75 && velocity.x >= -250 {
                show()
            } else {
                hide()
            }
            
        default:
            break
        }
    }
}
