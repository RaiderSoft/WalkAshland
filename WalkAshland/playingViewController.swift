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
import AVFoundation

class playingViewController: UIViewController {
    //This is the initial starting point for the tour
    //var placesClient: GMSPlacesClient!
    
    //Created by Dylan
    //The audio player
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 42.1972 , longitude: 122.7153, zoom: 9.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        //placesClient = GMSPlacesClient.shared()


        let position = CLLocationCoordinate2D(latitude: 42.1972, longitude: 122.7153)

        let marker = GMSMarker(position: position)
        marker.title = "HELLO WORLD"
        marker.map = mapView

        let marker2 = GMSMarker(position: CLLocationCoordinate2D(latitude: 42.5, longitude: 122.7153))
        marker2.title = "Hll"
        marker2.map = mapView
        
       //Created by Dylan
       //bring mediabar forward
       MediaBar.layer.zPosition = 1;
       
       //Do - try - catch audio player for file sample.wav
       do {
           audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Find_Money", ofType: "mp3")!))
           
       } catch {
           print(error)
       }
    
    }
    
    //Created By Dylan
    //audio player outlets and actions
    //media tool bar
    @IBOutlet weak var MediaBar: UIToolbar!

    //play
    @IBAction func Play(_ sender: Any) {
        audioPlayer.play()
    }
    //pause
    @IBAction func Pause(_ sender: Any) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    //rewind
    @IBAction func Rewind(_ sender: Any) {
    }
    //fastforward
    @IBAction func FastForward(_ sender: Any) {
    }
    
    @IBOutlet weak var ViewForMap: UIView!
}
