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
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik


/*  This class is the class for the tours view controller that list the tours   */
class toursViewController: UITableViewController {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
   
    //Creating variable to be set from the scene delegate for the data
    var dataModel: DataModel?
    //To store dowloaded tours from the model
    var tours: [Tour] {
        
        return dataModel?.tours ?? []   }
    //Create a reference to the firebase storage for accessing files
    let storageRef = Storage.storage().reference()
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This function is called before the view will be loaded
    //I used this function to reload the data on the table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //dataModel?.retrieve_data()
        NSLog("in toursviewcont tours count is \(tours.count)")
        tableView.reloadData()
        
        }
    
    //This function sets the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tour = tours[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! tourCell
        
        cell.titleOut.text = tour.title
        cell.aboutOut.text = tour.description
        cell.durNumOut.text = "\(tour.duration) mins"
        /*
            Download the image and view is
            Create a reference to this image from the firebase storage
         */
        let imageRef = storageRef.child("ashland2.jpg") //Change this to get from specif folder of images
        
        //a default image
        let defImage = UIImage(named: "ashland1")
        
        //load the image
        cell.imgOut!.sd_setImage(with: imageRef, placeholderImage: defImage)
        
        //Setup all static images for a cell
        cell.typeImgOut.image = UIImage.init(named: "walking")
        cell.durImgOut.image = UIImage.init(named: "timeicon")
        cell.distImgOut.image = UIImage.init(named: "locationicon")
        
    return cell
    }
    
    
     //SEND the this tour data on clicking
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tourInfo = segue.destination as? tourInfo,
            
            let index = tableView.indexPathForSelectedRow?.row
            else {
                guard let playSc = segue.destination as? playingViewController,
                    let index1 = tableView.indexPathForSelectedRow?.row
                    else {
                        return
                }
                playSc.tour = tours[index1]
                return
        }
        tourInfo.tour = tours[index]
        
        
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
    
    
    @IBOutlet weak var durNumOut: UILabel!
    @IBOutlet weak var imgOut: UIImageView!
    
    @IBOutlet weak var aboutOut: UITextView!
    @IBOutlet weak var titleOut: UILabel!
    
}
 


