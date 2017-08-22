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
    
    var travel: Travel!
    var sortedTransactions: Results<Transaction>!
    var markers = [TransactionGMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortedTransactions = travel.transactions.sorted(byKeyPath: "dateInRegion.date", ascending: false).filter("lat != nil AND lng != nil")
        
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        createMapView()
        addMarker()
    }
    
    func createMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 51.5, longitude: -0.127, zoom: 13)
        mapView.camera = camera
    }
    
    func addMarker() {
        var bounds = GMSCoordinateBounds()
        
        markers = [TransactionGMSMarker]()
        
        for transaction in sortedTransactions {
            guard let position = transaction.coordinate else { continue }
            
            let marker = TransactionGMSMarker()
            marker.position = position
            marker.transaction = transaction
            marker.title = transaction.name
            marker.snippet = "\(transaction.amount) \(transaction.currency!.code)"
            marker.map = mapView
            
            bounds = bounds.includingCoordinate(marker.position)
            markers.append(marker)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView.animate(with: update)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

class TransactionGMSMarker: GMSMarker {
    var transaction: Transaction?
    
    override init() {
        super.init()
    }
}

extension TransactionMapViewController: GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        let marker = marker as! TransactionGMSMarker
//        let storyboard = UIStoryboard(name: "TransactionPopUpViewController", bundle: nil)
//        let popUpViewController = storyboard.instantiateViewController(withIdentifier: "TransactionPopUpViewController") as! TransactionPopUpViewController
//        popUpViewController.transaction = marker.transaction
//        popUpViewController.modalPresentationStyle = .overCurrentContext
//        present(popUpViewController, animated: false)
//        
//        return true
//    }
}

extension TransactionMapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedTransactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionMapCell", for: indexPath) as! TransactionMapCollectionViewCell
        
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
        
        let transaction = sortedTransactions[indexPath.row]
        cell.nameLabel.text = transaction.name
        cell.dateLabel.text = transaction.dateInRegion?.string()
        cell.amountLabel.text = "\(transaction.amount) \(transaction.currency!.code)"
        
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2, y: collectionView.contentOffset.y + collectionView.bounds.height/2)
        guard let indexPath = collectionView.indexPathForItem(at: currentCenteredPoint) else { return }
        
        let transaction = sortedTransactions[indexPath.row]
        print(transaction.name)

        let update = GMSCameraUpdate.setTarget(transaction.coordinate!)
        mapView.animate(with: update)
        
        let marker = markers[indexPath.row]
        mapView.selectedMarker = marker
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 20.0, height: 90.0)
    }
}
