//
//  playingViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 4/10/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

//  COMMENTIG STYLE   FOR FAISAL-ALIK
//  //###FAISAL
//  CODE
//  //***ALIK

import UIKit
import GoogleMaps
import GooglePlaces
import AVFoundation

class playingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    //Created by Dylan
    //The audio player
    var audioPlayer = AVAudioPlayer()
    
    //List Text for drop down(PickerTextView)
    var audioList: [String] = [String]()
    
    
    
    
    /* ######################### Faisal Alik  ###########################
        Declaring necessary variables
     */
    var camera:GMSCameraPosition?   //Used to hold a camera object ref
    var mapView: GMSMapView?        //Used to hold a map object ref
    
    //A dummy variable late will store the real values pass of the location points
    var locationPoints: [[String: Double]] = [  [   "long": 34.3, "lat": 35.3],
                                                [   "long": 34.4, "lat": 35.2],
                                                [   "long": 34.1, "lat": 35.5]  ]
    //Declare an array that will hold the markers corespoding to the location points
    var tourPointMarkers: [GMSMarker]?
    
    //create a path
    let tourPath = GMSMutablePath()  //will indicate the path of the tour
    
    //The google api for accessing directions
    var baseURL = "https://maps.googleapis.com/maps/api/directions/json?"
    //*******************************************************************-Alik
    
    
    
    /* This is linked to the action button to display and make disapear the picker view*/
    @IBAction func DisplayList(_ sender: Any) {
        //##################################################################-Faisal
        //Handling picker view interactions
        if PickerTextView.isHidden {
            PickerTextView.isHidden = false
            PickerTextView.isUserInteractionEnabled = true
        }
        else {
            PickerTextView.isHidden = true
            PickerTextView.isUserInteractionEnabled = false
        }//******************************************************************-Alik
    }
    
    func changeMarker(i:Int){

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //###############################################################-Faisal
        //Get the longitude and latitude of the centeral point in the
        //tour and set as the center of the camera
        if let lon = locationPoints[Int(locationPoints.count/2)]["long"],
            let lat = locationPoints[Int(locationPoints.count/2)]["lat"]
        {
            //Create a camera with the above center focused
            camera = GMSCameraPosition.camera(withLatitude: lon , longitude: lat, zoom: 4)
        }
        else
        {
            //take care of the error by alerting
            NSLog("Error: reading long and lati")
        }
        //Check if the camera is successfuly created
        if let camera = camera {
            //Create a map view with this camera
            mapView = GMSMapView.map(withFrame: self.view.subviews.first?.frame ?? self.view.frame, camera: camera)
            mapView?.isUserInteractionEnabled = true
            mapView?.isBuildingsEnabled = true

        }
        else{
            //Take care of the error 
        }
        for point in locationPoints {   //loop through the locationpoints array
            //Unwrap both longitude and latitude
            if let long = point["long"], let lat = point["lat"]
            {
                //Create and append a marker to the array of markers
                let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: long, longitude: lat))
                marker.map = self.mapView                //Set the map for the marker so it is being showed
                marker.icon = GMSMarker.markerImage(with: UIColor.black)
                tourPointMarkers?.append(marker)    //add the new marker to the array
                
                //Add the points to the tour
                tourPath.add(CLLocationCoordinate2D.init(latitude: long, longitude: lat))                      //
                
            }
            else{
                NSLog("\n\n\n\n ERROR \n\n\n")
            }
            if let markers = tourPointMarkers {
                markers[0].icon = GMSMarker.markerImage(with: UIColor.red)
            }
            //Create a polyline from the path of the tour points
            let tourLine = GMSPolyline(path: tourPath)
            tourLine.strokeWidth = 4                //Set the thickness of the line
            //This line of code will go when one audio is finished listening
            
            tourLine.map = mapView
        }
        
        //Setup the maps url
        //USE if need the direction otherwise only draw streaght lines between the points
        //Google charges for direction api call
        baseURL += "origin=\(locationPoints[0])&destination=\(locationPoints[1])&mode=walking&key=AIzaSyDjNpvuv_eW0ogWbHevj3MWwll2El58mW0"
        

        
        //***************************************************************-Alik
        
        
        
        
        
        
        
        
       //Created by Dylan
       //bring mediabar forward
       MediaBar.layer.zPosition = 1;
       
       //Do - try - catch audio player for file sample.wav
       do {
           audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Find_Money", ofType: "mp3")!))
           
       } catch {
           print(error)
       }
        
        //mapView.settings.setAllGesturesEnabled(false)
        //used for Drop down menu(PickerTextView)
        self.PickerTextView.delegate = self
        self.PickerTextView.dataSource = self
        
        //text for Drop down menu(PickerTextView)
        audioList = ["Track 1", "Track 2", "Track 3"]
        
        
        
        
        
        //###############################################################-Faisal
        //Checking if the mapView exists
        if let map = mapView {
            self.view.addSubview(map)               //Adding the mapview as a subview
            mapView?.addSubview(PickerTextView)     //Adding the pickerview to the mapview
        }
        //***************************************************************-Alik
    }
    

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //number of components in the drop down(PickerTextView)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows for drop down(PickerTextView)
    //equal to the amount of elements in audiolist
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return audioList.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        PickerTextView.text = audioList[row]
//    }
    
    //Names of the elements in drop down(PickerTextView) equal to elements in audioList
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return audioList[row]
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
    
    //Drop Down Menu
    @IBOutlet weak var PickerTextView: UIPickerView!
    

    

}
