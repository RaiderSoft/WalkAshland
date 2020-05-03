//
//  DataModel.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

//A tour consists of multiple attributes
struct Tour {
    
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
    
    var title: String  //The Tour title
    var description: String  //A description about the tour viewed as about
    var price: String = "3.00"  //The price of a toure currently 3.00 dollars
    var imgPath: String  ////An image to be displayed in as a preview image

    
    var duration: String  //The Duraction of tour in minutes
    var tourType: String = "Walking"  //To store the type of the tour can be Walking, ByCar, Terain For now just Walking
    
    //location points on this tour
    //location points are labeled with integer numbers that coresponds to a point with latitude and logntitude
    var locationPoints: [[String: Double]] // location is stored as latitude and longitude
    
    //Not sure Need to be edited
    var audioClips: [String]

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
    
}

// save
extension UIImage {

    func save(at directory: FileManager.SearchPathDirectory,
              pathAndImageName: String,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
        let documentsDirectory = try FileManager.default.url(for: directory, in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: false)
        return save(at: documentsDirectory.appendingPathComponent(pathAndImageName),
                    createSubdirectoriesIfNeed: createSubdirectoriesIfNeed,
                    compressionQuality: compressionQuality)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }

    func save(at url: URL,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
            if createSubdirectoriesIfNeed {
                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }
            guard let data = jpegData(compressionQuality: compressionQuality) else { return nil }
            try data.write(to: url)
            return url
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}

// load from path
extension UIImage {
    convenience init?(fileURLWithPath url: URL, scale: CGFloat = 1.0) {
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data, scale: scale)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}

class DataModel {

    //Getting a reference to the database
    var databaseRef: DatabaseReference!
    //Get a reference to the storage
    let storage = Storage.storage()
    
    //List of available tours
    var tours: [Tour] = []
    

    
    func retrieve_data(){
        
        
        //Reference to the database
        self.databaseRef = Database.database().reference()

        var x : Int = 0
        while x < 1 {
            
            databaseRef.child("db").child("\(x)").observeSingleEvent(of: .value, with: { (data) in
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
                

//                // Get the saved Car object
//                if let car = getObject(fileName: "Title") as? Tour {
//                    print("The title is: \(car)")
//                }
                
                //add the tour to the tours list
                self.tours.append(t)


                
              }) { (error) in
                print(error.localizedDescription)
                
            }
            
            x += 1 //The code will be improved to download all available tours
        }
        
        // save image
        let path = "/ashland1.jpeg"
        guard   let img = UIImage(named: "ashland1"),
                let url = img.save(at: .documentDirectory,
                                   pathAndImageName: path) else { return }
        print(url)
        
        
        
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
