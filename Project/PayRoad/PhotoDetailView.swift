//
//  PhotoDetailView.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 25..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var originFrame = CGRect()
    weak var delegate: PhotoDetailViewController!

    @IBOutlet weak var zoomScrollView: UIScrollView!
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        zoomScrollView.delegate = self
        zoomScrollView.maximumZoomScale = 5
        zoomScrollView.minimumZoomScale = 1
        
        let doubleTapGuesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapGuesture(_:)))
        doubleTapGuesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGuesture)
        
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(dismissDownPanGesture(_:)))
        panGuesture.delegate = self
        panGuesture.maximumNumberOfTouches = 1
        detailImageView.addGestureRecognizer(panGuesture)
    }
    
    func dismissDownPanGesture(_ sender: UIPanGestureRecognizer) {
        let targetView = sender.view!
        let translation = sender.translation(in: targetView)
        
        switch sender.state {
        case .began:
            originFrame = sender.view!.frame
            
        case .changed:
            let addY = translation.y <= 0 && originFrame.midY >= targetView.frame.midY ? 0 : translation.y

            targetView.center = CGPoint(
                x: targetView.center.x,
                y: targetView.center.y + addY
            )
            sender.setTranslation(CGPoint.zero, in: targetView)
            let diff = targetView.center.y - frame.height
            let value = abs(diff / targetView.center.y)
            if value <= 1 && zoomScrollView.zoomScale == 1 {
                delegate.baseBlackView.alpha = value
            }
            
        case .ended:
            let velocity = sender.velocity(in: targetView)
            
            if velocity.y >= 200 && abs(velocity.x) <= 550 && zoomScrollView.zoomScale == 1 {
                let targetSize = targetView.frame.size

                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    UIApplication.shared.isStatusBarHidden = false
                    targetView.frame.origin.y = self.frame.maxY
                    targetView.frame.size = CGSize(
                        width: targetSize.width * 0.5,
                        height: targetSize.height * 0.5
                    )
                    self.delegate.baseBlackView.alpha = 0
                }, completion: { [unowned self] _ in
                    self.restoreView(view: targetView)
                    self.delegate.dismiss(animated: false, completion: nil)
                })
                
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: { [unowned self] in
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
        delegate.baseBlackView.alpha = 1
    }
    
    func resetZoomScale() {
        zoomScrollView.setZoomScale(1, animated: true)
    }
    
    func didDoubleTapGuesture(_ sender: UITapGestureRecognizer) {
        if zoomScrollView.zoomScale == 1 {
            zoomScrollView.setZoomScale(2.5, animated: true)
        } else {
            zoomScrollView.setZoomScale(1, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.detailImageView
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
