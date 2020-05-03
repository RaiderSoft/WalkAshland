//
//  DataModel.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.

/*** Initial Programmer ::: Faisal Alik        *******/

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
import Foundation
import UIKit
import Firebase             //Needed to create instances of firebase bucket
import FirebaseStorage      //Needed to create and access file inside firebase storage
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik


//This class defines a tour object consisting of the required fields
struct Tour {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This is the initializer, that can be used to create object of this class by passing required values
    init(ti: String, des: String, pr: String, img: String, dur: String , type: String, locs: [[String:Double]], auds: [String]) {
        self.title = ti
        self.description = des
        self.price = pr
        self.imgPath = img
        self.duration = dur
        self.tourType = type
        self.locationPoints = locs
        self.audioClips = auds
    }
    var title: String                           //The Tour title
    var description: String                     //A description about the tour viewed as about
    var price: String = "3.00"                  //The price of a toure currently 3.00 dollars
    var imgPath: String                         //An image to be displayed in as a preview image
    var duration: String                        //The Duraction of tour in minutes
    var tourType: String = "Walking"            //To store the type of the tour can be Walking, ByCar, Terain For now just Walking
    var locationPoints: [[String: Double]]      // location is stored as an array of latitude and longitude
    var audioClips: [String]                    //Not sure Need to be edited
    //This function returns a dictiory of values in the object
    var saveTourDetail: [String: String] {
    
        return [
        "title": "\(title)",
        "about": "\(description)",
        "price": "\(price)",
        "image": "\(imgPath)",
        "duration": "\(duration)",
        "type": "\(tourType)"
        
        ]
    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
}
class DataModel {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
    //List of available tours
    var tours: [Tour] = []
    //Getting a reference to the database
    var databaseRef: DatabaseReference!
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    
    
    func retrieve_data(){
        //
        //Get a reference to the storage
        //let storage = Storage.storage()
        
        
        //Reference to the database
        databaseRef = Database.database().reference()

        databaseRef.child("db").observeSingleEvent(of: .value, with: { (toursData) in
            let toursCount = toursData.childrenCount - 1
            var iterator = 0
            while(iterator <= toursCount){
                self.databaseRef.child("db").child("\(iterator)").observeSingleEvent(of: .value, with: { (data) in
                    // Get user value
                    
                    let tour = data.value as? NSDictionary
                    //Get individual values of a tour from the database
                    let title = tour?["title"] as! String
                    let description = tour?["about"] as! String
                    let price = tour?["price"] as! String
                    let type = tour?["type"] as! String
                    let image = tour?["image"] as! String
                    let duration = tour?["duration"] as! String
                    let location = tour?["locations"] as! [[String: Double]]
                    //Create a tour
                    let t = Tour.init(ti: title, des: description, pr: price, img: image, dur: duration, type: type , locs: location, auds:["This","That"])
                    //add the tour to the tours list
                    self.tours.append(t)
                    NSLog("INside the db call toursCount\(self.tours.count)")
                })
                { (error) in
                    //print(error.localizedDescription)
                    
                }
                iterator += 1
            }
        })
        {   (error) in
            //print(error.localizedDescription)
        }
        /*
        if saveObject(fileName: "Title", object: tours) {
            print("saved")
        } else {
            print("not saved")
        }
        
        if let t = getObject(fileName: "Title") as? Tour {
            print("Tour is: \(t)")
        }
        */
        
        
        
        /* Getting a file from the Firebase storage
        var img = UIImage.init(named: "ashland2")
        
        //create s storage ref
        let storageRef = storage.reference()
        //storageRef.child("")
        
        //LocalFileto upload
        let localFile = URL(string: "./ashland2")
        
        //create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "ashland2/jpeg"
        
        //upload file and metadata to the object 'image/ashland2.jpg'
        let uploadTask = storageRef.putFile(from: localFile!, metadata: metadata)
        */
        //listen for state changes, errors, and completion of the upload
        
        /****/
        
        ///let imageRef = storageRef.child("img/ashland2")

    }
    
}

//################################################################-Dylan
// Save object in document directory
func saveObject(fileName: String, object: Any) -> Bool {
    
    let filePath = getDirectoryPath().appendingPathComponent(fileName)
    do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        try data.write(to: filePath)
        return true
    } catch {
        print("error is: \(error.localizedDescription)")
    }
    return false
}
// Get object from document directory
func getObject(fileName: String) -> Any? {
    
    let filePath = getDirectoryPath().appendingPathComponent(fileName)
    do {
        let data = try Data(contentsOf: filePath)
        let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        return object
    } catch {
        print("error is: \(error.localizedDescription)")
    }
    return nil
}
                                                                                //SHOULD HAVE THESE FUNCTIONS OUTSIDE ANY CLASS??
//Get the document directory path
func getDirectoryPath() -> URL {
    let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return arrayPaths[0]
}
//*****************************************************************-Pitts

