//
//  addLocationsViewControllers.swift
//  WalkAshland
//
//  Created by Faisal Alik on 4/12/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import SDWebImage
import SDWebImageWebPCoder


class addLocationsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create a camera and position it to a certain place
        let camera = GMSCameraPosition.camera(withLatitude: 42.1972 , longitude: 122.7153, zoom: 9.0)
        //create a mapview and add the camera
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        //add the mapview to the viewcontroller
        self.view.addSubview(mapView)
        
        mapView.isMyLocationEnabled = true
        mapView.isMultipleTouchEnabled = true

    }
    
}
