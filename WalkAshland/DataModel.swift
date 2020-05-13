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

let storage = Storage.storage()
 
let storageRef = storage.reference()

//This class defines a tour object consisting of the required fields
struct Tour {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This is the initializer, that can be used to create object of this class by passing required values
    init(ti: String, des: String, pr: String, img: String, dur: String , type: String, locs: [[String:Double]], auds: [String], flag: String) {
        self.title = ti
        self.description = des
        self.price = pr
        self.imgPath = img
        self.duration = dur
        self.tourType = type
        self.locationPoints = locs
        self.audioClips = auds
        self.flag = flag
        
        
    }
    var title: String                           //The Tour title
    var description: String                     //A description about the tour viewed as about
    var price: String = "3.00"                  //The price of a toure currently 3.00 dollars
    var imgPath: String                         //An image to be displayed in as a preview image
    var duration: String                        //The Duraction of tour in minutes
    var tourType: String = "Walking"            //To store the type of the tour can be Walking, ByCar, Terain For now just Walking
    var locationPoints: [[String: Double]]      // location is stored as an array of latitude and longitude
    var audioClips: [String]                    //Not sure Need to be edited
    
    var flag: String                            //Possible [D,P,ND,NP]
    
    //This function returns a dictiory of values in the object
    var saveTourDetail: [String: String] {
    
        return [
        "title": "\(title)",
        "about": "\(description)",
        "price": "\(price)",
        "image": "\(imgPath)",
        "duration": "\(duration)",
        "type": "\(tourType)",
        "audio": "\(audioClips)"
        ]
    }
    
}

class DataModel {

    //Getting a reference to the database
    var databaseRef: DatabaseReference!
    //Get a reference to the storage
 
    
    //List of available tours
    var tours: [Tour] = []
    // Array of files
    
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
                    let audio = tour?["audios"] as! [String]
                    
                    //Create a tour
                    let t = Tour.init(ti: title, des: description, pr: price, img: image, dur: duration, type: type , locs: location, auds: audio, flag: "ND")
                    
                    
                    //add the tour to the tours list
                    self.tours.append(t)
                    
                    for aud in audio {
                        
                        let audDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let audLocalURL = audDocumentsURL.appendingPathComponent(aud)
                        
                        // Create a reference to the file you want to download
                        let audRef = storageRef.child(aud)

                        // Download to the local filesystem
                        _ = audRef.write(toFile: audLocalURL) { (URL, error) -> Void in
                          if (error != nil) {
                            // Uh-oh, an error occurred!
                            print("Error: File Not Saved")
                          } else {
                            // Local file URL for "images/island.jpg" is returned
                            print("File Saved")
                            print(audLocalURL)
                          }
                        }
                        
                    }
                    
                    
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let localURL = documentsURL.appendingPathComponent(image)
                    
                    // Create a reference to the file you want to download
                    let islandRef = storageRef.child(image)

                    // Download to the local filesystem
                    _ = islandRef.write(toFile: localURL) { (URL, error) -> Void in
                      if (error != nil) {
                        // Uh-oh, an error occurred!
                        print("Error: File Not Saved")
                      } else {
                        // Local file URL for "images/island.jpg" is returned
                        print("File Saved")
                        print(localURL)
                      }
                    }

                    
                  })
                  { (error) in
                        NSLog("ERROR: Unable to open Firebase database")
                    }
                iterator += 1
                    
            }
        })
        { (error) in
            NSLog("ERROR: Unable to open Firebase database")
        }
    }
}
