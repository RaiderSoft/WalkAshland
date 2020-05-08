//
//  createTour.swift
//  WalkAshland
//
//  Created by Faisal Alik on 4/9/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage
import SDWebImageWebPCoder

class createTour: UIViewController {
   
        //Getting a reference to the database
    var databaseRef: DatabaseReference!
    //Get a reference to the storage
    let storage = Storage.storage()
    
    
    @IBOutlet weak var titleFieldOut: UITextField!
    //checking if the textfield is empty
    
    //working with the description field
    @IBOutlet weak var descriptionField: UITextView!
    
    //accessing type field
    @IBOutlet weak var typeField: UITextField!
    
    //accessing price field
    @IBOutlet weak var priceField: UITextField!
    

    @IBAction func createButton(_ sender: UIButton) {
        
        //Create a tour
        var tour: Tour?
        if let title = titleFieldOut.text,
            let desc = descriptionField.text,
            let type = typeField.text,
            let price = priceField.text {
//
//            tour = Tour.init(ti: title, des: desc, pr: price, img: "Arbitrary for now", dur: "23", type: type, locs: [["Longitude":33.4, "Latitude": 34.4]], auds: ["theis","That"])
            //Get the reference to the database
            self.databaseRef = Database.database().reference()
            
            //Get the current id of tours
    

            self.databaseRef.updateChildValues(
                [
                    "/db/8": tour?.saveTourDetail]
            )
            
            self.databaseRef.child("db").child("8").setValue(tour?.saveTourDetail)

        }
        
        

        
    }
    override func viewDidLoad() {

        /*
         //Getting a reference to the storage service using the defauld firebase app
         let storage = Storage.storage()
         
         //Create a storage reference from out storage service
         let storageRef = storage.reference()
         
         //create a child reference where the image file will be saved
         //let imageRef = storageRef.child("images/ashland2.jpg")
         
         
         //First way
         //Get the data in the memory
         let data = Data()
         
         //reference to the file being uploaded
         let ashlandRef = storageRef.child("images/ashland2.jpg")
         
         //upload the file to the path /images/ashland2.jpg
         let uploadTask = ashlandRef.putData(data, metadata: nil) {
         (metadata, error) in
         guard let metadata = metadata else {
         //in error case
         return
         }
         let size = metadata.size
         ashlandRef.downloadURL { (url, error) in
         guard let downloadURL = url else {
         //error occured
         return
         }
         }
         }
         
         
         
         
         


        //Write the array of tours from tours2 to the data base
        var i = 0
        //save data to the database
        for tour in tours2 {
            self.databaseRef.child("db").child("\(i)").setValue(tour.saveTourDetail)
            self.databaseRef.updateChildValues(
                [
                    "/db/\(i)/audios": tour.audioClips]
            )
            self.databaseRef.updateChildValues(
                [
                    "/db/\(i)/locations": tour.locationPoints ]
            )
            
            
            self.databaseRef.child("db").setValue(
             ["tours": [
             "title": "\(tours[0].title)",
             "about": "\(tours[0].description)",
             "location":"\(tours[0].locationPoints[0])",
             "image": "\(tours[0].imgPath)",
             "duration": "\(tours[0].duration)",
             "audios": "\(tours[0].audioClips)"
             
             ]
             ]
             )
            i += 1
        }
        */
    }
 
}
