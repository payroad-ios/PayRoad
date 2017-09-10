//
//  PhotoDetailViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 24..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

protocol PhotoDatailViewDelegate: class {
    func changedCurrentPhoto(_ page: Int)
}

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    fileprivate(set) weak var delegate: PhotoDatailViewDelegate?
    
    fileprivate(set) var photos: [Photo]!
    fileprivate(set) var selectedIndex: Int!
    fileprivate(set) var photoDetailViews = [PhotoDetailView]()
    
    fileprivate(set) var previousPage = 0
    fileprivate(set) var currentPage = 0 {
        didSet {
            photoDetailViews[previousPage].resetZoomScale()
            delegate?.changedCurrentPhoto(currentPage)
        }
    }
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var baseBlackView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        baseScrollView.delegate = self
        setupImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        closeButton.imageView?.image = closeButton.imageView?.image?.withRenderingMode(.alwaysTemplate)

        showSelectedIndexImage(index: selectedIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    func setupImageView() {
        for (index, item) in photos.enumerated() {
            let photoDetailView = UINib(nibName: "PhotoDetailView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PhotoDetailView
            
            photoDetailView.set(delegate: self)
            photoDetailView.detailImageView.image = item.fetchPhoto()
            
            let dynamicX = self.view.frame.width * CGFloat(index)
            photoDetailView.frame = CGRect(x: dynamicX, y: 0, width: photoDetailView.frame.width, height: photoDetailView.frame.height)
            baseScrollView.contentSize.width = baseScrollView.frame.width * CGFloat(index + 1)
            
            baseScrollView.addSubview(photoDetailView)
            photoDetailViews.append(photoDetailView)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / view.frame.width))
        previousPage = page
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / view.frame.width))
        if currentPage != page {
            currentPage = page
        }
    }
    
    func showSelectedIndexImage(index: Int) {
        let newOffset = view.frame.width * CGFloat(index)
        baseScrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: true)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        UIApplication.shared.isStatusBarHidden = false
        photoDetailViews[currentPage].resetZoomScale()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func removePhotoDetailViews() {
        photoDetailViews.forEach {
            $0.removeFromSuperview()
            $0.set(delegate: nil)
        }
        photoDetailViews = [PhotoDetailView]()
    }
    
    deinit {
        removePhotoDetailViews()
    }
}

extension PhotoDetailViewController {
    func set(delegate: PhotoDatailViewDelegate?) {
        self.delegate = delegate
    }
    
    func set(photos: [Photo]) {
        self.photos = photos
    }
    
    func set(selectedIndex: Int?) {
        self.selectedIndex = selectedIndex
    }
}
