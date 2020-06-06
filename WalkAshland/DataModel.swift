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


let storage = Storage.storage() //To access the firebase storage
let storageRef = storage.reference()    //To access firebase storage
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
//This class defines a tour object consisting of the required fields
struct Tour {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This is the initializer, that can be used to create object of this class by passing required values
    init(ti: String, des: String, pr: String, img: String, dur: String , type: String, locs: [[String:Double]], auds: [String],photos:[String], flag: String) {
        self.title = ti
        self.description = des
        self.price = pr
        self.imgPath = img
        self.duration = dur
        self.tourType = type
        self.locationPoints = locs
        self.audioClips = auds
        self.flag = flag
        self.photos = photos
        
    }
    var title: String                           //The Tour title
    var description: String                     //A description about the tour viewed as about
    var price: String = "3.00"                  //The price of a toure currently 3.00 dollars
    var imgPath: String                         //An image to be displayed in as a preview image
    var duration: String                        //The Duraction of tour in minutes
    var tourType: String = "Walking"            //To store the type of the tour can be Walking, ByCar, Terain For now just Walking
    var locationPoints: [[String: Double]]      // location is stored as an array of latitude and longitude
    var audioClips: [String]                    //Not sure Need to be edited
    var photos: [String]
    var flag: String = "NP"                     //Possible [D,P,ND,NP]      if D then P / if NP then ND / P -> D | ND / IF ND -> P | NP
    
    //This function returns a dictiory of values in the object
    var saveTourDetail: [String: String] {
    
        return [
        "title": "\(title)",
        "about": "\(description)",
        "price": "\(price)",
        "image": "\(imgPath)",
        "duration": "\(duration)",
        "type": "\(tourType)",
        "audio": "\(audioClips)",
        "photos": "\(photos)"
        ]
    }
    
}

class DataModel {

    //Getting a reference to the database
    var databaseRef: DatabaseReference!
    //Get a reference to the storage
 
    
    //List of available tours
    var tours: [Tour] = []
    var purchasedTours: [Tour] = []
    var user : User?        //To hold the login information
    // Array of files
    
    func savePurchase(user uid: User, tour tid: Int){
            self.databaseRef = Database.database().reference()
                    
                    //Update the user info can user this code
            
    //
    //                self.databaseRef.updateChildValues(
    //                    [
    //                        "/users/": user.saveUserDetail]
    //                )

            //Check if the user exists in the database
        self.databaseRef.child("purchaseditems").child("\(uid.id)").child("tours").observeSingleEvent(of: .value, with: { (data) in
                //add the user to the database if not exists
                
                if data.childrenCount == 0 {
                    //Set the very first purchased item of the user
                    self.databaseRef.child("purchaseditems").child("\(uid.id)").child("tours").child("0").setValue(tid)
                    
                }
                else {
                    
                    self.databaseRef.child("purchaseditems").child("\(uid.id)").observeSingleEvent(of: .value, with: { (dat) in

                        let tourids = dat.value as? NSDictionary
                        
                        if let tourids = tourids  {
                            let toursc = tourids["tours"] as? [Int]

                            var numPurchasedTours = 0

                            
                            if let num = toursc?.count {
                                numPurchasedTours = num
                            }
                            if let ts = toursc {
                                //CHeck if the purchased tour is already added
                                if !(ts.contains(tid)){
                                    self.databaseRef.child("purchaseditems").child("\(uid.id)").child("tours").child("\(numPurchasedTours)").setValue(tid)
                                }
                            }

                        }
                    })
                }
            })
            { (error) in
                NSLog("ERROR: Unable to open Firebase database")
            }
        }
    
    //Save user login
    func saveuserinfo(user u: User) -> Bool{
        var added = false
        self.databaseRef = Database.database().reference()
                
                //Update the user info can user this code
        
//
//                self.databaseRef.updateChildValues(
//                    [
//                        "/users/": user.saveUserDetail]
//                )

        //Check if the user exists in the database
        self.databaseRef.child("user").child("\(u.id)").observeSingleEvent(of: .value, with: { (data) in
            //add the user to the database if not exists
            if data.childrenCount == 0 {
                self.databaseRef.child("users").child("\(u.id)").setValue(u.saveUserDetail)
                added = true
            }
            else {
                added = false
                //
            }
        })
        { (error) in
            NSLog("ERROR: Unable to open Firebase database")
        }
        return added
    }
    func getPurchasedFor(userId id: String, tours t: [Tour]){
        //Reference to the database
        databaseRef = Database.database().reference()
        
            //Check if the user exists in the database
        
        self.databaseRef.child("purchaseditems").child("\(id)").child("tours").observeSingleEvent(of: .value, with: { (data) in
                //add the user to the database if not exists
                
                if data.childrenCount != 0 {
                    //Set the very first purchased item of the user
                    
                    self.databaseRef.child("purchaseditems").child("\(id)").observeSingleEvent(of: .value, with: { (dat) in
                        
                        let tourids = dat.value as? NSDictionary

                        if let tourids = tourids  {
                            //Get the list of the purchased tours
                            
                            if let toursc = tourids["tours"] as? [Int] {
                                //CHeck if the purchased tour is already added
                                NSLog("count of toursc is \(toursc.count)" )
                                print(tourids)
                                NSLog("RE HERE \n id is \(id) \n ")
                                
                                for i in toursc {
                                    print("i is : \(i)")
                                    self.databaseRef.child("db").child("\(i)").observeSingleEvent(of: .value, with: { (data) in
                                                      
                                        print("enter 1 ")
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
                                        print("enter 2 ")
                                        let photos = tour?["photos"] as! [String]

                                        //Check if there is more photos than the default preview image al
                                        if true {
                                            var x = 0
                                            while x < photos.count {
                                                print("enter 3 ")
                                                let photo = photos[x]
                                                //Get local storage reference
                                                let documentsPhotoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                                //create a reference to the file
                                                let localPhotoURL = documentsPhotoURL.appendingPathComponent(photo)
                                                //get firestore reference for the image
                                                let photoRef = storageRef.child(photo)
                                                
                                                let _ = photoRef.write(toFile: localPhotoURL) { (URL, error) -> Void in
                                                    if (error == nil) {
                                                        NSLog("Got the file in Getpurchased")
                                                        if let url = URL {
                                                            //Added this path to the array of paths to local photos
                                                            print(url)
                                                        }
                                                    }
                                                    else {
                                                        NSLog("Error occured")
                                                    }
                                                }
                                                x += 1
                                            }
                                            
                                        }
                                         //Create a tour
                                         let x = Tour.init(ti: title, des: description, pr: price, img: image, dur: duration, type: type , locs: location, auds: audio,photos: photos, flag: "ND")

                                        //add the tour to the tours list
                                        self.purchasedTours.append(x)
                                                      
                                       // ?????? NEEd TO LIMIT TO DOWNLOAD A CERTIAN NUMBEER OF AUDIOS
                                        
                                        //**********************************************************************DYlan
                                        for aud in audio {
                                                          
                                            let audDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                            let audLocalURL = audDocumentsURL.appendingPathComponent(aud)
                                                
                                                // Create a reference to the file you want to download
                                            let audRef = storageRef.child(aud)
                                            
                                            // Download to the local filesystem
                                            _ = audRef.write(toFile: audLocalURL)
                                            { (URL, error) -> Void in
                                                if (error != nil) {
                                                    // Uh-oh, an error occurred!
                                                    print("Error: File Not Saved")
                                                } else {
                                                    // Local file URL for "images/island.jpg" is returned
//                                                    print("File Saved")
//                                                    print(audLocalURL)
                                                }
                                            }
                                        }
//                                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                                        let localURL = documentsURL.appendingPathComponent(image)
//
//                                        // Create a reference to the file you want to download
//                                        let islandRef = storageRef.child(image)
//                                        // Download to the local filesystem
//                                        _ = islandRef.write(toFile: localURL) { (URL, error) -> Void in
//                                        if (error != nil) {
//                                                          // Uh-oh, an error occurred!
//                                            print("Error: File Not Saved")
//                                        } else {
//                                        // Local file URL for "images/island.jpg" is returned
//                                            print("File Saved")
//                                            print(localURL)
//                                        }
//                                        }
                                        //########################################################################Pitts
                                    })
                                    { (error) in
                                        NSLog("ERROR: Unable to open Firebase database")
                                    }
                                }
                            }
                        }
                    })
                }
        })
    }
    func retrieve_data(){
        NSLog("Datamodel is called")
        //Get a reference to the storage
        //let storage = Storage.storage()
        var photolocked: Bool = false
        
        //Reference to the database
        databaseRef = Database.database().reference()

        
        databaseRef.child("db").observeSingleEvent(of: .value, with: { (toursData) in
            let toursCount = toursData.childrenCount - 1
            var iterator = 0
            while(iterator <= toursCount){
                //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
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
                    let photos = tour?["photos"] as! [String]
                    
                    
                    for photo in photos {
                        if !photolocked {
                            //Get local storage reference
                            let documentsPhotoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            //create a reference to the file
                            let localPhotoURL = documentsPhotoURL.appendingPathComponent(photo)
                            //get firestore reference for the image
                            print("Photo is \(photo) \n")
                            print("iterator is \(iterator)")
                            let photoRef = storageRef.child("photos").child(String(iterator-1)).child(photo)
                            print(photoRef)
                            let _ = photoRef.write(toFile: localPhotoURL) { (URL, error) -> Void in
                                if (error == nil) {
                                    NSLog("Got the file")
                                    if let url = URL {
                                        //Added this path to the array of paths to local photos
                                        print(url)
                                        print("THis worked")
                                    }
                                }
                                else {
                                    NSLog("Error occured")
                                }
                            }
                            photolocked = true
                        }


                    }
                    
                    
                    //Create a tour
                    let t = Tour.init(ti: title, des: description, pr: price, img: image, dur: duration, type: type , locs: location, auds: audio,photos: photos, flag: "ND")
                    //add the tour to the tours list
                    self.tours.append(t)
                    
                    
                    // ?????? NEEd TO LIMIT TO DOWNLOAD A CERTIAN NUMBEER OF AUDIOS
                     
                     //**********************************************************************DYlan
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
//                            print("File Saved")
//                            print(audLocalURL)
                          }
                        }
                        
                    }
                    
                    
//                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    let localURL = documentsURL.appendingPathComponent(image)
//
//                    // Create a reference to the file you want to download
//                    let islandRef = storageRef.child(image)
//
//                    // Download to the local filesystem
//                    _ = islandRef.write(toFile: localURL) { (URL, error) -> Void in
//                      if (error != nil) {
//                        // Uh-oh, an error occurred!
//                        print("Error: File Not Saved")
//                      } else {
//                        // Local file URL for "images/island.jpg" is returned
//                        print("File Saved")
//                        print(localURL)
//                      }
//                    }
                     //########################################################################Pitts
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
