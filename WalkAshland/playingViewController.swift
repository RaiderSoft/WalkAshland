//
//  playingViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 4/10/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class playingViewController: UIViewController {
    //This is the initial starting point for the tour
    //var placesClient: GMSPlacesClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 42.1972 , longitude: 122.7153, zoom: 9.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        self.view.addSubview(mapView)
        
        //Allow corrent location accessing
        
        
        //placesClient = GMSPlacesClient.shared()
        
        
        let position = CLLocationCoordinate2D(latitude: 42.1972, longitude: 122.7153)
        
        let marker = GMSMarker(position: position)
        marker.title = "HELLO WORLD"
        marker.map = mapView
        
        let marker2 = GMSMarker(position: CLLocationCoordinate2D(latitude: 42.5, longitude: 122.7153))
        marker2.title = "Hll"
        marker2.map = mapView
        
    }
    
    
}
