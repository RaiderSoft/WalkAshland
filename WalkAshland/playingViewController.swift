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
import GooglePlaces
import GoogleMaps

class nplayingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //Need to recieve the selected tour information
    var tour: Tour?                                          //This will recieve data from the tour list
    var distanceAway: Double!                                //The distance of the user from the starting of the tour is set from tourslist
    @IBOutlet weak var mapView: GMSMapView!                 //An outlet to the mapkit view
    var currentLocation: CLLocationCoordinate2D!             //stores the current location of the user
    let locationManager = CLLocationManager()                //Creating a location manager to manage accessing user's location
//    let directionRequest = MKDirections.Request()            //Creating a request of direction
    
    var locationPoints: [GMSMarker]!
    var nextPoint: CLLocationCoordinate2D?
    var counter = 0;
//    var notVisited : Bool = true  //For tracking is a location is visited
//
//    var direction: MKDirections?
//
    //>>>> GOOGLe Directions
    var baseURL = "https://maps.googleapis.com/maps/api/directions/json?"
    var baseURLDirections: URL?
    let directionsAPIKey = "AIzaSyALhYJ57z7cqPzn8jLMMM1pxmhZIgmiG-8"
    var waypoints: String = "&waypoints=via:"
    var camera : GMSCameraPosition?
    let documentsDirectoryPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
   
    @IBOutlet weak var photOut: UIImageView!
    @IBOutlet weak var photosOut: UIButton!
    @IBAction func photosGo(_ sender: UIButton) {

    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
     //SEND this tour data on clicking
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    let documentsDirectoryPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let pvc = segue.destination as? photosViewController {
            var images: [UIImage] = []
            var names: [String] = []
            
            var i = 0
            
            if let tour = tour {
                while (i < tour.photos.count){
                    let prevImagePath =  URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(tour.photos[i])
                    let image = UIImage(contentsOfFile: prevImagePath.path)
                    if let image = image {
                        images.append(image) //Add image
                        
                        let name : String = tour.photos[i]
                        
                        let index = name.index(name.endIndex, offsetBy: -4)
                        var newName = ""
                        let ti = name[..<index]
                        for i in ti {
                            newName = "\(newName)\(i)"
                        }
                        
                        names.append(newName)
                        
                    }
                    i += 1
                }
            }
            pvc.imageNames = names
            pvc.images = images
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
    
    //###############################################################-Dylan
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
            //nextPoint = locationPoints[row].position
        } catch {
            //print(error)
        }
    }
    
    func openMapForPlace() {

        let lat1 = self.tour?.locationPoints[0]["Latitude"]
        let lng1 = self.tour?.locationPoints[0]["Longitude"]

        let latitude:CLLocationDegrees =  lat1 ?? 42.2
        let longitude:CLLocationDegrees =  lng1 ?? 122.7

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "current location"
        mapItem.openInMaps(launchOptions: options)

    }
    //Created By Dylan
    //audio player outlets and actions
    //media tool bar
    @IBOutlet weak var MediaBar: UIToolbar!
    //play
    @IBAction func Play(_ sender: Any) {
        audioPlayer.play()
        //getRout()    only if from one location to the other
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
    //******************************************************************-Pitts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        if let tour = tour {
            let prevImagePath =  URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(tour.photos[0])
            let image = UIImage(contentsOfFile: prevImagePath.path)
            photOut.image = image
            view.addSubview(photOut)
            photosOut.tag = 0
        }
        //>>>>Google STUFF
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var x = 0
        if let tour = tour {
            for point in tour.locationPoints {                                                     //loop through the locationpoints array
                //Unwrap both longitude and latitude
                if let long = point["Longitude"], let lat = point["Latitude"]
                {
                    //Create a marker
                    let an =  GMSMarker(position: CLLocationCoordinate2D.init(latitude: lat, longitude: long))
                    let image = UIImage(named: "m\(x+1)")
                    an.icon = image
                    an.title = String(x+1)            //The tile of the marker is the number associated with p
                    
                    if locationPoints == nil {  //if the locationPoints is emtpy just add the first locationp
                        
                        locationPoints = [an]
//                        baseURL = baseURL + "origin=\(an.position.latitude),\(an.position.longitude)"
                    }
                    else {
                        locationPoints.append(an)

//                        var exists = false
//                        for a in locationPoints {
//                            if (a.position.latitude == an.position.latitude) && (a.position.longitude == an.position.longitude) {
//                                exists = true
//                                a.title = a.title! + String(x)
//                            }
//                        }
//                        if !exists {
//                            an.title = String(x)            //tour.audioClips[x] as? String
//                        }
                        if x < tour.locationPoints.count - 1 {
                            waypoints = waypoints + "\(an.position.latitude)%2C\(an.position.longitude)%7Cvia:"
                        }
                        else {
                            waypoints = waypoints + "\(an.position.latitude)%2C\(an.position.longitude)"
                        }
                        
                    }
                    //change the icon or color of the annotation
                }
                else{  NSLog("ERROR: Unable to get the location points for the tour.")  }
                x = x + 1
            }
            baseURL = baseURL + "origin=\(locationPoints[0].position.latitude),\(locationPoints[0].position.longitude)&destination=\(locationPoints[locationPoints.count-1].position.latitude),\(locationPoints[locationPoints.count-1].position.longitude)"
            baseURL = baseURL + waypoints + "&sensor=true&mode=walking&key=\(directionsAPIKey)"
            baseURLDirections = URL(string: baseURL)
        }
        else {
            //Alert
            let alertController = UIAlertController(title: "Distance", message: "Unable to download this tour \n please make sure you are connected to the internet.", preferredStyle: .alert)
              alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
              alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: {
                
                action in
                self.reloadInputViews()
                self.loadView()
                
            }))
            self.present(alertController,animated: true, completion: nil)
        }
        nextPoint = locationPoints[counter].position
        
        //get the consent of the user for accessing current location
        
        locationManager.requestWhenInUseAuthorization()
        //Update current location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //Get the start and destinations
        //Start with ziro change somehow
        if  let sourceLong = tour!.locationPoints[0]["Longitude"]           //get the longitude of the last
            ,let sourceLat = tour!.locationPoints[0]["Latitude"]
        {
            camera = GMSCameraPosition(latitude: sourceLat, longitude: sourceLong, zoom: 15.0)
        }
        else {
            //print("ERROR default setup of google map api")
        }
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = true
        mapView.isMultipleTouchEnabled = true
        mapView.isUserInteractionEnabled = true
        if distanceAway == nil {       //Default miles away
            distanceAway = 23.00    //This is in miles
        }
        //Get the route form the google
        let task = session.dataTask(with: baseURLDirections!, completionHandler: {
                (data, response, error) in
                if error != nil {
                    //print(error!.localizedDescription)
                }
                else {
                    do {
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{

//                            guard let routes = json["routes"] as? NSArray else {
//                                    return
//                            }
                            let status = json["status"] as? String
                            NSLog(String("\n\n\n Status is \n \(status)"))
                            if status == "OK" {
                                let routes = json["routes"] as? [Any]
                                let aroute = routes?[0] as? [String:Any]
                                let overview = aroute?["overview_polyline"] as? [String: Any]
                                let polyline = overview?["points"] as? String

                                DispatchQueue.main.async {
                                    let path = GMSPath(fromEncodedPath: polyline!)
                                    let lines = GMSPolyline(path: path)
                                    lines.strokeWidth = 4.0
                                    lines.strokeColor = UIColor.blue

                                    lines.map = self.mapView
                                }
                            }
                        }
                    }
                    catch {
                        //print("error in JSONSerialization")
                    }
                }
            })
            task.resume()
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
        
        
        //###############################################################-Dylan
        //Created by Dylan
        //let fileManager = FileManager.default
        // MARK: TODO: For loop should stop after it has reached locked audios
        var i = 0
        if let tours = tour?.audioClips {
            for aud in tours {

                let fileManager = FileManager.default

                i += 1
                //text for Drop down menu(PickerTextView)
                let path = documentsDirectoryPath + "/" + aud
                // Check if file exists, given its path
                if fileManager.fileExists(atPath: path) {
                    audioList.append("Chapter " + String(i))
                    audioPath.append(path)
                } else {
                    break
                }
            }
        }
       //bring mediabar forward
       MediaBar.layer.zPosition = 3;
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath[0]))
             audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }
            catch {
                
            }
            
            
         } catch {
             //print(error)
         }
        //mapView.settings.setAllGesturesEnabled(false)
        //used for Drop down menu(PickerTextView)
        self.PickerTextView.delegate = self
        self.PickerTextView.dataSource = self
        //******************************************************************-Pitts
        
        
        
        
        mapView?.addSubview(PickerTextView)     //Adding the pickerview to the mapview
        if distanceAway > 1.0 {
            let cam = GMSCameraPosition(latitude: nextPoint!.longitude , longitude: nextPoint!.longitude, zoom: 10.0)
            
          let alertController = UIAlertController(title: "Distance", message: "You are far away \nFor navigation click on map,\nor click dismiss. \nWhen you get near the starting location,\n the tour will start automatically,\nOr you can play each audio tour manually.", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
          alertController.addAction(UIAlertAction(title: "Navigate", style: .default, handler: {
            
            action in
            self.openMapForPlace()      //#####Dylan
            
        }))
        self.present(alertController,animated: true, completion: nil)
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
            reloadInputViews()
        }
        if let camera = camera {
            mapView.camera = camera
        }
        
        for i in locationPoints {
            i.map = mapView
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadInputViews()
    }
}

/*
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
    This extension takes care of all location tracking
 */
extension nplayingViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    /* This is linked to the action button to display and make disapear the picker view >>>Faisal */
    @IBAction func DisplayList(_ sender: Any) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
        //Handling picker view interactions
        if PickerTextView.isHidden {                        //unhide the pickerview if its hiden
            PickerTextView.isHidden = false
            PickerTextView.isUserInteractionEnabled = true  //allow the user to interact with pickerview
        }
        else {
            PickerTextView.isHidden = true                  //otherwise hide the pickerview
            PickerTextView.isUserInteractionEnabled = false
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
    }
    /*      In this function we check for user authorization of using the location  >>>>Faisal    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
        if status == .authorizedWhenInUse || status == .authorizedAlways {             //check if the user has given authorization
            locationManager.requestLocation()           //Request the location of user
            locationManager.allowsBackgroundLocationUpdates = true
        }
        else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
        
    }
    /*      In this function we take action for errors from     >>>>Faisal  */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("ERROR:: \(error) ")
    }
    func getRout(){
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
        //11.1 meters
        let spread = CLLocationCoordinate2D.init(latitude: 0.0001, longitude: 0.0001)
        if let nextP = self.nextPoint {
            if (self.currentLocation.latitude > nextP.latitude - spread.latitude &&
                self.currentLocation.longitude < nextP.latitude + spread.latitude )
                && (self.currentLocation.longitude > nextP.longitude - spread.longitude &&
                    self.currentLocation.longitude < nextP.longitude + spread.longitude)
            {
                if self.counter < self.locationPoints.count && !(self.audioPlayer.isPlaying){
                    do {

                        self.locationPoints[self.counter].icon = UIImage.init(named: "listening")
                        self.locationPoints[self.counter].title = "Playing"
                        self.locationPoints[self.counter].map = mapView
                        self.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: self.audioPath[self.counter]))
                        self.audioPlayer.play()
                        
                        //check if th counter is greater than zero and smaller max
                        if self.counter < self.locationPoints.count && self.counter > 0  {
                            self.locationPoints[self.counter-1].icon = UIImage.init(named: "m\(self.counter)")
                            self.locationPoints[self.counter-1].title = "\(self.counter-1)"
                        }
                        
                        self.counter = self.counter + 1
                        
                        if self.counter < self.locationPoints.count {
                            
                            self.nextPoint = self.locationPoints[self.counter].position
                        }
                        if let tour = tour {
                            
                            if ( photosOut.tag <= tour.photos.count){
                                
                                let prevImagePath =  URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(tour.photos[photosOut.tag])
                                let image = UIImage(contentsOfFile: prevImagePath.path)
                                if let image = image {
                                    //print(" \n\n\n IN PHOTO ARES ")
                                    self.photOut.image = image
                                    self.view.addSubview(photOut)
                                     //Add image
                                    self.photosOut.tag = self.photosOut.tag + 1
                                }
                            }
                        }
                    } catch {
                        //print(error)
                    }
                }
                else if !(self.audioPlayer.isPlaying) {
                    do {
                        //A Thank or something
                        self.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: self.audioPath[self.counter]))
                        self.audioPlayer.play()
                        self.counter = 0
                        self.nextPoint = self.locationPoints[self.counter].position
                    } catch {
                        //print(error)
                    }
                }
                else {
                    
                }
            }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
        }
        //Start with ziro change somehow
        if  let destinationLat = tour?.locationPoints[((tour?.locationPoints.count)! - 1)]["Latitude"],            //
            let destinationLong = tour?.locationPoints[((tour?.locationPoints.count)! - 1)]["Longitude"],
            let sourceLong = tour!.locationPoints[0]["Longitude"]           //get the longitude of the last
            ,let sourceLat = tour!.locationPoints[0]["Latitude"]
            
        {                                                                                                   //The source and distenation of the requested direction
            if distanceAway < 1.0  {
//                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: nextPoint!.latitude , longitude: nextPoint!.longitude)))
//
//                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude , longitude: currentLocation.longitude)))
//
//            }
//            directionRequest.requestsAlternateRoutes = false        //Set alternative paths to none
//            directionRequest.transportType = .walking               //Default transport type is walking
//
//
//            direction = MKDirections(request: directionRequest)     //request a direction from the source to the direction
//
//            direction?.calculate { (response, error) in             //Get an process the respons to the the direction request
//                guard let directionResponse = response else {
//                    if let error = error {
//                        NSLog("ERROR: \t Failed on unwrapping response: \(error)")
//                    }
//                    return
//                }
//                let route = directionResponse.routes[0]             //Get the first posible route
//                // NSLog("next point lat : \(self.nextPoint?.latitude) \n next point long : \(self.nextPoint?.longitude)")
//                //one meters in feet
//                //let distance = route.distance          //distance in miles
//                //NSLog("Calculated   distance \(distance)")
//
//                self.mapView.addOverlay(route.polyline)
//
//                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
            }

            
        }
    }
    
    /*  This function updates the user's location      >>>>Faisal */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //  let locationPoints = gets from tour             //Get the location points create annotations
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locValue
        
        //Set the region where the mapview should focus on
        //Get the longitude and latitude of the centeral point in the
        //tour and set as the center of the camera
        getRout()
        reloadInputViews()
    }
}//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik

