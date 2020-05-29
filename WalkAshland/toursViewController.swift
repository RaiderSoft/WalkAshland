//
//  toursViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
import UIKit
import Firebase     //needed for using Firebase database and referencing the db
import FirebaseUI   //
import SDWebImage   //Needed for using active loading of an image from the firebase storage
import SDWebImageWebPCoder
import SwiftUI
import MapKit
import CoreLocation //For accesing the curent location
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik


/*  This class is the class for the tours view controller that list the tours   */
class toursViewController: UITableViewController, CLLocationManagerDelegate{
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //Creating variable to be set from the scene delegate for the data
    var dataModel: DataModel?
    //To store dowloaded tours from the model
    var tours: [Tour] {
        return dataModel?.tours ?? []
    }
    var user : User!
    var distance: Double!
    //Create a reference to the firebase storage for accessing files
    let storageRef = Storage.storage().reference()
    let locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    let directionRequest = MKDirections.Request()            //Creating a request of direction
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Reached \(user)")
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }


        reloadInputViews()
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This function is called before the view will be loaded
    //I used this function to reload the data on the table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    /*      In this function we check for user authorization of using the location  >>>>Faisal    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {             //check if the user has given authorization
            locationManager.requestLocation()           //Request the location of user
        }
        else {
            NSLog("COULD not access location")
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
        /*
         if( locationPoints[0]["lat"]! + CLLocationCoordinate2D.init(latitude: 0.00015, longitude: 0.0015).latitude > locValue.latitude
            && locValue.latitude > locationPoints[0]["lat"]! - CLLocationCoordinate2D.init(latitude: 0.00015, longitude: 0.0015).latitude)
        {
            print(" \n\n\nlocations = \(locValue.latitude) \(locValue.longitude) \n\n")
        }
        */
        
        //Set the region where the mapview should focus on
        //Get the longitude and latitude of the centeral point in the
        //tour and set as the center of the camera
        loadView()
        
    }
    
    //This function sets the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        let tour = tours[indexPath.row]             //For each row create a cell  with cell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! tourCell
        //Setup all static images for a cell
        cell.typeImgOut.image = UIImage.init(named: "walking")
        cell.durImgOut.image = UIImage.init(named: "timeicon")
        cell.distImgOut.image = UIImage.init(named: "locationicon")
        
        //Take care of location and distance
        
        //For now [0] later location and photos
        if  let destinationLat = tour.locationPoints[0]["Latitude"],        //latitude of starting point of the location
            let destinationLong = tour.locationPoints[0]["Longitude"],      //longitude 0f /////
            let sourceLong = currentLocation?.longitude                     //longitude of user's curent location
            ,let sourceLat = currentLocation?.latitude                      //latitude of //////
            {                                                               //The source and distenation ofthe requested direction
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLat , longitude: destinationLong)))
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sourceLat , longitude: sourceLong)))
            }
               

               
        directionRequest.requestsAlternateRoutes = false                //Set alternative paths to none
        directionRequest.transportType = .automobile                       //Default transport type is walking
        let directions = MKDirections(request: directionRequest)        //request a direction from the source to the direction
        directions.calculate { (response, error) in                     //Get an process the respons to the the direction request
            guard let directionResponse = response else {
                if let error = error {
                        NSLog("ERROR: \t Failed on unwrapping response: \(error)")
                }
                return
            }
            let route = directionResponse.routes[0]                     //Get the first posible route
            //Foot const
            let toFeet = 3.28084                                        //one meters in feet
            let toMile = 5280.0                                         //one mile in feets
            self.distance = (route.distance * toFeet) / toMile           //distance in miles
            cell.distLabelOut.text = "\( round((self.distance / 0.01 ) * 0.01)) miles away"        //Set the distance label in the view
        }
        let t : String = tour.title                                     //These steps are for truncating the title to a file size
        var title = ""
        if t.count > 15 {
            let index = t.index(t.startIndex, offsetBy: 25)
            let ti = t[..<index] 
            for i in ti {
                title = "\(title)\(i)"
            }
            cell.titleOut.text = title                                  //Set the title to the new lenght
        }
        else {
            cell.titleOut.text = tour.title                             //Set the title of the tour
        }                                                               //These steps are to truncate the desription to fine size
        let d : String = tour.description
        var description = ""
        if d.count > 15 {
            let index = d.index(d.startIndex, offsetBy: 100)
            let de = d[..<index]
            for i in de {
                description = "\(description)\(i)"
            }
            cell.aboutOut.text = description    }
        else {
            cell.aboutOut.text = tour.description                       //Set description of the tour
        }
        cell.durNumOut.text = "\(tour.duration) mins"                   //Set the duration of the tour
        cell.typeLabelOut.text = tour.tourType                          //Set the type of the tour
        
        /*
            Download the image and view is
            Create a reference to this image from the firebase storage
         */
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(tour.imgPath)
            let image    = UIImage(contentsOfFile: imageURL.path)
            cell.imgOut.image = image
           // Do whatever you want with the image
        }
        
        cell.startOut.tag = indexPath.row                               //A way to p
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    return cell
    }
    
     //SEND this tour data on clicking
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        if let index = tableView.indexPathForSelectedRow?.row {
            if let tourInfo = segue.destination as? tourInfo {
               tourInfo.tour = tours[index]
            }
        }
        if let playSc = segue.destination as? playingViewController {
            if let obj = sender as? UIButton {
                playSc.tour = tours[obj.tag]
                playSc.distanceAway = distance
            }
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
}


/* Faisal:
   This class handles */
class tourCell: UITableViewCell {
    

    @IBOutlet weak var durImgOut: UIImageView!
    @IBOutlet weak var typeLabelOut: UILabel!
    @IBOutlet weak var typeImgOut: UIImageView!
    @IBOutlet weak var distLabelOut: UILabel!
    @IBOutlet weak var distImgOut: UIImageView!
    
    //This is for the button to be labeled download, start, or purchase (price)
    @IBOutlet weak var PDSButtonOut: UIButton!
    @IBOutlet weak var startOut: UIButton!
    
    @IBOutlet weak var durNumOut: UILabel!
    @IBOutlet weak var imgOut: UIImageView!
    
    @IBOutlet weak var aboutOut: UILabel!
    @IBOutlet weak var titleOut: UILabel!
    
    
}
 


