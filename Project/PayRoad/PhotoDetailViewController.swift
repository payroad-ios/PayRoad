//
//  PhotoDetailViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 24..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    var photos: [Photo]!
    var selectedIndex: Int!
    var imageArray = [UIImage]()
    var originFrame = CGRect()
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    
    override func viewDidLoad() {
        
        let doubleTapGuesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapGuesture(_:)))
        doubleTapGuesture.numberOfTapsRequired = 2
        
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(dismissDownPanGesture(_:)))
        
        baseScrollView.delegate = self
        baseScrollView.maximumZoomScale = 5
        baseScrollView.minimumZoomScale = 1
        
        view.addGestureRecognizer(doubleTapGuesture)
        detailImageView.addGestureRecognizer(panGuesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showSelectedIndexImage()
        restoreView(view: detailImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    func setupImageView() {
        
    }
    
    func showSelectedIndexImage() {
        detailImageView.image = photos[selectedIndex].fetchPhoto()
    }
    
    func dismissDownPanGesture(_ sender: UIPanGestureRecognizer) {
        let targetView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            originFrame = sender.view!.frame
            
        case .changed:
            targetView.center = CGPoint(
                x: targetView.center.x + translation.x,
                y: targetView.center.y + translation.y
            )
            sender.setTranslation(CGPoint.zero, in: targetView)
            
            let diff = targetView.center.y - view.frame.height
            let value = abs(diff / targetView.center.y)
            if value <= 1 {
                UIApplication.shared.isStatusBarHidden = false
                baseView.alpha = value
            }
            
        case .ended:
            let velocity = sender.velocity(in: targetView)
            
            if velocity.y >= 200 {
                let targetSize = targetView.frame.size
                UIView.animate(withDuration: 0.2, animations: {
                    targetView.frame.origin.y = targetSize.height
                    targetView.frame.size = CGSize(
                        width: targetSize.width * 0.5,
                        height: targetSize.height * 0.5
                    )
                }, completion: { (bool) in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                    UIApplication.shared.isStatusBarHidden = true
                    self.restoreView(view: targetView)
                }, completion: nil)
            }
        default:
            break
        }
    }
    
    func restoreView(view: UIView) {
        view.frame = self.originFrame
        
        self.baseView.alpha = 1
    }
    
    func didDoubleTapGuesture(_ sender: UITapGestureRecognizer) {
        if baseScrollView.zoomScale == 1 {
            baseScrollView.setZoomScale(2.5, animated: true)
        } else {
            baseScrollView.setZoomScale(1, animated: true)
        }
    }
    
    func panDownGuesture(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.detailImageView
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
