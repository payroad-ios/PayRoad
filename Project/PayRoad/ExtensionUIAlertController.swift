//
//  ExtensionUIAlertController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 17..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func oneButtonAlert(target: UIViewController, title: String?, message: String?) {
        let alertController = self.init(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(closeAction)
        target.present(alertController, animated: true, completion: nil)
    }
    
    static func confirmStyleAlert(target: UIViewController, title: String, message: String?, buttonTitle: String?, handler: @escaping (UIAlertAction) -> Void){
        let alertController = self.init(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: buttonTitle ?? "확인", style: .destructive, handler: handler)
        alertController.addAction(closeAction)
        alertController.addAction(confirmAction)
        target.present(alertController, animated: true, completion: nil)
    }
}
