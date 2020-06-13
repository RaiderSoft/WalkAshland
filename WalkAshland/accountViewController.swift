//
//  accountViewController.swift
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

extension accountViewController {
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
}
/*  This class is the class for the tours view controller that list the tours   */
class accountViewController: UITableViewController, CLLocationManagerDelegate{
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //Creating variable to be set from the scene delegate for the data
    var dataModel: DataModel?
    //To store dowloaded tours from the model
    var tours: [Tour]!
    var user : User!
    var distance: Double!
    var duration: Double!
    //Create a reference to the firebase storage for accessing files
    let storageRef = Storage.storage().reference()
    let locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    let directionRequest = MKDirections.Request()            //Creating a request of direction
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal

        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        reloadInputViews()
        loadView()
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tourinfo", sender: nil)
    }
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This function is called before the view will be loaded
    //I used this function to reload the data on the table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = dataModel?.user {
            self.user = user
        }
        dataModel!.getPurchasedFor(userId: user.id, tours: dataModel!.tours)      //sharing not sharing email, has different ids

        tours = dataModel?.purchasedTours

        reloadInputViews()
        loadView()
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }

    /*  This function updates the user's location      >>>>Faisal */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        //  let locationPoints = gets from tour             //Get the location points create annotations
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locValue
        locationManager.stopUpdatingLocation()

        //Set the region where the mapview should focus on
        //Get the longitude and latitude of the centeral point in the
        //tour and set as the center of the camera
        tours = dataModel?.purchasedTours

        reloadInputViews()
        loadView()
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
        
    }
    //This function sets the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        if editingStyle == .delete {
            tours.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        let tour = tours[indexPath.row]             //For each row create a cell  with cell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! tourCell
        //Setup all static images for a cell
        cell.typeImgOut.image = UIImage.init(named: "walking")
        cell.durImgOut.image = UIImage.init(named: "clock")
        cell.distImgOut.image = UIImage.init(named: "distance")
        
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
        directionRequest.transportType = .walking                       //Default transport type is walking
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
            if route.distance * toFeet > toMile {
                self.distance = (route.distance * toFeet) / toMile           //distance in miles
                cell.distLabelOut.text = "\( round((self.distance / 0.01 ) * 0.01)) miles away"
            }
            else{
                self.distance = route.distance * toFeet
                cell.distLabelOut.text = "\( round((self.distance / 0.01 ) * 0.01)) fts away"
            }
            //Set the distance label in the view
        }
        //Trim the title to a fitting size
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
        }
        //Trim the description to a fitting size
        let d : String = tour.description                               //These steps are to truncate the desription to fine size
        var description = ""
        if d.count > 150 {
            let index = d.index(d.startIndex, offsetBy: 150)
            let de = d[..<index]
            for i in de {
                description = "\(description)\(i)"
            }
            cell.aboutOut.text = description    }
        else {
            cell.aboutOut.text = tour.description                       //Set description of the tour
        }
        cell.durNumOut.text = "\(tour.duration)"                   //Set the duration of the tour
        cell.typeLabelOut.text = tour.tourType                          //Set the type of the tour
        
        /*
            Download the image and view is
            Create a reference to this image from the firebase storage
         */
        let documentsDirectoryPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let prevImagePath =  URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(tour.photos[0])
        let image = UIImage(contentsOfFile: prevImagePath.path)
        cell.imgOut.image = image
        cell.PDSButtonOut.isHidden = true
        cell.PDSButtonOut.isEnabled = false 
        
        cell.startOut.tag = indexPath.row                               //A way to p
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.reloadInputViews()
    }
     //SEND this tour data on clicking
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        if let index = tableView.indexPathForSelectedRow?.row {
            if let tourInfo = segue.destination as? tourInfo {
               tourInfo.tour = tours[index]
               tourInfo.distance = self.distance
            }
        }
        if let playSc = segue.destination as? nplayingViewController {
            if let obj = sender as? UIButton {
                playSc.tour = tours[obj.tag]
                playSc.distanceAway = self.distance
            }
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
}
 

