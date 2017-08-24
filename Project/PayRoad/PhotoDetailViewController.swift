//
//  PhotoDetailViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 24..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        UIApplication.shared.isStatusBarHidden = true
        baseScrollView.delegate = self
        baseScrollView.maximumZoomScale = 5
        baseScrollView.minimumZoomScale = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.detailImageView
    }
    
}
