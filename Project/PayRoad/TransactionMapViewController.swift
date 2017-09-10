//
//  TransactionMapViewController.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 20..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import GoogleMaps
import RealmSwift

class TransactionMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) var transactionsNotificationToken: NotificationToken? = nil
    fileprivate(set) var travel: Travel!
    fileprivate(set) var sortedTransactions: Results<Transaction>!
    fileprivate(set) var markers = [TransactionGMSMarker]()
    fileprivate(set) var currentSelectedMarkerIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        sortedTransactions = travel.transactions.sorted(byKeyPath: "dateInRegion.date").filter("lat != nil AND lng != nil")
        
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        createMapView()
        
        transactionsNotificationToken = sortedTransactions.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.mapView.clear()
            self?.addMarker()
            self?.currentSelectedMarkerIndex = 0
            self?.collectionView.reloadData()
        }
        
    }
    
    func createMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 51.5, longitude: -0.127, zoom: 13)
        mapView.camera = camera
    }
    
    func addMarker() {
        var bounds = GMSCoordinateBounds()
        
        markers = [TransactionGMSMarker]()
        
        let path = GMSMutablePath()
        
        for (index, transaction) in sortedTransactions.enumerated() {
            guard let position = transaction.coordinate else { continue }
            
            let marker = TransactionGMSMarker()
            marker.position = position
            marker.transaction = transaction
            marker.appearAnimation = .pop
            marker.map = mapView
            
            bounds = bounds.includingCoordinate(marker.position)
            markers.append(marker)
            
            let transactionMarkerView = TransactionMapMarkerView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
            transactionMarkerView.setTextLabel(text: "\(transaction.amount.nonZeroString(maxDecimalPlace: 2, option: .seperator)) \(transaction.currency!.code)")
           
            marker.iconView = transactionMarkerView
            marker.zIndex = Int32(index)
            
            path.add(position)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView.animate(with: update)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.geodesic = true
        polyline.strokeColor = .black
        polyline.map = mapView
    }
    
    func changeSelectedMarker(new newMarker: GMSMarker) {
        for (index, marker) in markers.enumerated() {
            if marker == newMarker && index != currentSelectedMarkerIndex {
                currentSelectedMarkerIndex = index
                marker.zIndex = Int32(markers.count)
                marker.iconView?.backgroundColor = UIColor.lightGray
                mapView.animate(toZoom: 16)
                collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
            } else {
                marker.zIndex = Int32(index)
                marker.iconView?.backgroundColor = UIColor.white
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransactionDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let transactionDetailViewController = segue.destination as! TransactionDetailViewController
                transactionDetailViewController.set(transaction: sortedTransactions[indexPath.row])
            }
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension TransactionMapViewController {
    func set(travel: Travel) {
        self.travel = travel
    }
}

class TransactionGMSMarker: GMSMarker {
    var transaction: Transaction?
    
    override init() {
        super.init()
    }
}

extension TransactionMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        changeSelectedMarker(new: marker)
        
        return true
    }
}

extension TransactionMapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedTransactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionMapCell", for: indexPath) as! TransactionMapCollectionViewCell
        
        let transaction = sortedTransactions[indexPath.row]
        cell.nameLabel.text = transaction.name
        cell.dateLabel.text = transaction.dateInRegion?.string()
        cell.amountLabel.text = "\(transaction.amount) \(transaction.currency!.code)"
        
        if let thumbnailImage = transaction.photos.first?.fetchPhoto() {
            cell.thumbnailImageView.image = thumbnailImage
        } else {
            cell.thumbnailImageView.image = #imageLiteral(resourceName: "Icon_ImageDefault")
        }
        
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2, y: collectionView.contentOffset.y + collectionView.bounds.height/2)
        guard let indexPath = collectionView.indexPathForItem(at: currentCenteredPoint) else { return }
        
        let transaction = sortedTransactions[indexPath.row]

        let update = GMSCameraUpdate.setTarget(transaction.coordinate!)
        mapView.animate(with: update)
        
        let marker = markers[indexPath.row]
        mapView.selectedMarker = marker
        
        changeSelectedMarker(new: marker)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 90.0)
    }
}
