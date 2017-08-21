//
//  TransactionMapViewController.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 20..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import GoogleMaps

class TransactionMapViewController: UIViewController {
    
    var mapView: GMSMapView!
    var travel: Travel!
    
    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 51.5, longitude: -0.127, zoom: 13)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)

        view = mapView
        
        mapView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var bounds = GMSCoordinateBounds()
        
        for transaction in travel.transactions {
            guard let position = transaction.coordinate else { continue }
            
            //let marker = GMSMarker()
            let marker = TransactionGMSMarker()
            marker.position = position
            marker.transaction = transaction
            marker.title = transaction.name
            marker.snippet = "\(transaction.amount) \(transaction.currency!.code)"
            marker.map = mapView
            
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView.animate(with: update)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension TransactionMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let marker = marker as! TransactionGMSMarker
        let storyboard = UIStoryboard(name: "TransactionPopUpViewController", bundle: nil)
        let popUpViewController = storyboard.instantiateViewController(withIdentifier: "TransactionPopUpViewController") as! TransactionPopUpViewController
        popUpViewController.transaction = marker.transaction
        popUpViewController.modalPresentationStyle = .overCurrentContext
        present(popUpViewController, animated: false)
        
        return true
    }
}

// 테스트
class TransactionGMSMarker: GMSMarker {
    var transaction: Transaction?
    
    override init() {
        super.init()
    }
}
