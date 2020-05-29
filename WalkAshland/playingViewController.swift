//
//  playingViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 4/10/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

//  COMMENTIG STYLE   FOR FAISAL-ALIK
//  //>>>FAISAL
//  CODE
//  //<<<<ALIK


import UIKit
import MapKit
import CoreLocation
import AVFoundation //Dylan


class playingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //Need to recieve the selected tour information
    var tour: Tour?                                          //This will recieve data from the tour list
    var distanceAway: Double!                                //The distance of the user from the starting of the tour is set from tourslist
    @IBOutlet weak var mapView: MKMapView!                   //An outlet to the mapkit view
    var currentLocation: CLLocationCoordinate2D!             //stores the current location of the user
    var routes : [MKRoute]!                                   //Stores the routes from start to destination
    let locationManager = CLLocationManager()                //Creating a location manager to manage accessing user's location
    let directionRequest = MKDirections.Request()            //Creating a request of direction
    var locationPoints: [Ano]{
        var locationPs : [Ano]!
        var i = 0
        for point in tour!.locationPoints {                                                     //loop through the locationpoints array
            //Unwrap both longitude and latitude
            if let long = point["Longitude"], let lat = point["Latitude"]
            {
                let an = Ano(id:(tour?.audioClips[i])! ,name: "Ti", lat: lat, long: long)                                                  //create an annotations

                if locationPs == nil {
                    locationPs = [an]
                }
                else {
                    locationPs.append(an)
                }
                //change the icon or color of the annotation
            }
            else{  NSLog("ERROR: Unable to get the location points for the tour.")                }
            i = i + 1
        }
        return locationPs
    }
    var currentPin : Ano?
    var route : MKRoute?
    var nextPoint: CLLocationCoordinate2D?
    var counter = 0;
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
    
    
    
    //Created by Dylan
    //The audio player
    var audioPlayer = AVAudioPlayer()
    
    //List Text for drop down(PickerTextView)
    var audioList: [String] = [String]()

    var audioPath: [String] = [String]()
    
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
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath[row]))
                nextPoint = locationPoints[row].coordinate
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
            audioPlayer.currentTime -= 10    }
        //fastforward
        @IBAction func FastForward(_ sender: Any) {
            audioPlayer.currentTime += 10
        }
        
        //Drop Down Menu
        @IBOutlet weak var PickerTextView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //###############################################################-Faisal
        
        if  let startLong = tour!.locationPoints[0]["Longitude"]           //get the longitude of the last
            ,let startLat = tour!.locationPoints[0]["Latitude"]
        {
            nextPoint = locationPoints[counter].coordinate
        }
        
        //get the consent of the user for accessing current location
        currentPin = locationPoints[0]                      //The first pinned location
        
        locationManager.requestWhenInUseAuthorization()
        //Update current location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.isZoomEnabled = true
        mapView.isUserInteractionEnabled = true
        if distanceAway == nil {
            distanceAway = 23.00
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
        
        
        
        //Created by Dylan
        //let fileManager = FileManager.default
        let documentsDirectoryPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let tours = tour?.audioClips {
            for aud in tours {
                
                let audDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let audLocalURL = audDocumentsURL.appendingPathComponent(aud)
                //text for Drop down menu(PickerTextView)
                audioList.append(aud)
                let path = documentsDirectoryPath + "/" + aud
                print("\n \n \(aud) \n \n")
                audioPath.append(path)
            }
        }
       //bring mediabar forward
       MediaBar.layer.zPosition = 1;
        
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath[0]))
             
         } catch {
             print(error)
         }
        //mapView.settings.setAllGesturesEnabled(false)
        //used for Drop down menu(PickerTextView)
        self.PickerTextView.delegate = self
        self.PickerTextView.dataSource = self

        
        //###############################################################-Faisal
        mapView?.addSubview(PickerTextView)     //Adding the pickerview to the mapview
        
        if distanceAway > 1.0 {
            let alertController = UIAlertController(title: "Distance", message: "You are far away \nFor navigation click on map,\nor click dismiss. \nWhen you get near the starting location,\n the tour will start automatically,\nOr you can play each audio tour manually.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            alertController.addAction(UIAlertAction(title: "Navigate", style: .default, handler: {
                
                action in
                //Apple Maps
                if (UIApplication.shared.canOpenURL(URL.init(string: "http://maps.apple.com")! )) {
                    UIApplication.shared.open(URL.init(string: "http://maps.apple.com/?sll=\(self.tour?.locationPoints[0]["Latitude"]),\(self.tour?.locationPoints[0]["Longitude"])")!)

                    NSLog("longitude : \(self.tour?.locationPoints[0]["Longitude"]) \n Latitude: \(self.tour?.locationPoints[0]["Latitude"])")
                    
                }else {
                    NSLog("Can't use Apple Maps")
                }
                //Segue to map
                
            }))
            self.present(alertController,animated: true, completion: nil)
        }
        
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
        
        
    reloadInputViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadInputViews()
    }

}

/*
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
    This extension takes care of all location tracking
 */
extension playingViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationVisited(){
        
    }
    
    /* This is linked to the action button to display and make disapear the picker view >>>Faisal */
    @IBAction func DisplayList(_ sender: Any) {
        //Handling picker view interactions
        if PickerTextView.isHidden {                        //unhide the pickerview if its hiden
            PickerTextView.isHidden = false
            PickerTextView.isUserInteractionEnabled = true  //allow the user to interact with pickerview
        }
        else {
            PickerTextView.isHidden = true                  //otherwise hide the pickerview
            PickerTextView.isUserInteractionEnabled = false
        }
    }
    /*      In this function we check for user authorization of using the location  >>>>Faisal    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {             //check if the user has given authorization
            locationManager.requestLocation()           //Request the location of user
        }
    }
    /*      In this function we take action for errors from     >>>>Faisal  */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("ERROR:: \(error) ")
    }
    /*  This function updates the user's location      >>>>Faisal */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //  let locationPoints = gets from tour             //Get the location points create annotations
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locValue
        
        
        //more than 11 meters
        
        
        //Set the region where the mapview should focus on
        //Get the longitude and latitude of the centeral point in the
        //tour and set as the center of the camera
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)

        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationPoints[0].coordinate.latitude , longitude: locationPoints[0].coordinate.longitude), span: span)
        
        mapView.setRegion(region, animated: true)
        if locationPoints.count > 0 {
            for anPoint in locationPoints {
                mapView.addAnnotation(anPoint)
            }
            
        }
        else{           NSLog("ERROR: Unable to get the location points for the tour.")                }
        
        
        
        
        //Start with ziro change somehow
        if  let destinationLat = tour?.locationPoints[((tour?.locationPoints.count)! - 1)]["Latitude"],            //
            let destinationLong = tour?.locationPoints[((tour?.locationPoints.count)! - 1)]["Longitude"],
            let sourceLong = tour!.locationPoints[0]["Longitude"]           //get the longitude of the last
            ,let sourceLat = tour!.locationPoints[0]["Latitude"]
            
        {                                                                                                   //The source and distenation of the requested direction
            if distanceAway > 1.0 {
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLat , longitude: destinationLong)))
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sourceLat , longitude: sourceLong)))

                //Set an Alert
            }
            else {
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: nextPoint!.latitude , longitude: nextPoint!.longitude)))
                
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locValue.latitude , longitude: locValue.longitude)))
                    
            }
            directionRequest.requestsAlternateRoutes = false                //Set alternative paths to none
            directionRequest.transportType = .walking                       //Default transport type is walking
            
            
            let directions = MKDirections(request: directionRequest)        //request a direction from the source to the direction
            
            directions.calculate { (response, error) in                     //Get an process the respons to the the direction request
                guard let directionResponse = response else {
                    if let error = error {
                        NSLog("ERROR: \t Failed on unwrapping response: \(error)")
                    }
                    return
                }
                self.route = directionResponse.routes[0]                     //Get the first posible route
                let toFeet = 3.28084                                        //one meters in feet
                let distance = self.route!.distance * toFeet         //distance in miles
                if distance <= 20.0 {
                    if self.counter < self.locationPoints.count {
                        do {
                            self.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: self.audioPath[self.counter]))
                            self.audioPlayer.play()
                            
                        } catch {
                            print(error)
                        }
                        
                        self.counter = self.counter + 1
                        self.nextPoint = self.locationPoints[self.counter].coordinate
                        
                    }
                }
                
                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
                }

            
        }
        if let route = route {
            self.mapView.addOverlay(route.polyline)                     //Add this rout to the map

        }
    }
    
    /*      */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        NSLog("Render Callded")
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKPinAnnotationView
        guard let annotation = annotation as? Ano else { return nil }
        if let dequView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKPinAnnotationView{
            view = dequView
            
        }
        else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        view.pinTintColor = UIColor.green
        return view
    }
    
    func changePinColor(id : String) {
        
    }
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
/*      This class is for customizing the anotation displayed on the map    */
class Ano: NSObject, MKAnnotation{
    var identifier: String!
    var title: String?
    var coordinate: CLLocationCoordinate2D
    init(id: String, name:String,lat:CLLocationDegrees,long:CLLocationDegrees){
        identifier = id
        title = name
        coordinate = CLLocationCoordinate2DMake(lat, long)
    }
}//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik

