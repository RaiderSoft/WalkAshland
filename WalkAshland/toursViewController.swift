//
//  toursViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage
import SDWebImageWebPCoder

class toursViewController: UITableViewController {
    
    //creating a model instance
    var dataModel: DataModel? = DataModel()
    
    //To store dowloaded tours from the model
    var tours: [Tour] {
        return dataModel?.tours ?? []
    }
    
    //Create a reference to the firebase storage
    let storageRef = Storage.storage().reference()
    
    
    
    override func viewDidLoad() {
        
        //dataModel?.writeToFireBase()
        self.dataModel?.retrieve_data()
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
        

    }
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
         */
        //Create a reference to this image from the firebase storage
        let imageRef = storageRef.child("ashland2.jpg")
        
        //a default image
        let defImage = UIImage(named: "ashland1")
        
        //load the image
        cell.imgOut!.sd_setImage(with: imageRef, placeholderImage: defImage)
        


        
        
        cell.typeImgOut.image = UIImage.init(named: "walking")
        cell.durImgOut.image = UIImage.init(named: "timeicon")
        cell.distImgOut.image = UIImage.init(named: "locationicon")
        
    return cell
    }
    
    /*//SEND the this tour data on clicking
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tourInfo = segue.destination as? tourInfo,
            
            let index = tableView.indexPathForSelectedRow?.row
            else {
                return
        }
        tourInfo.tour = tours[index]
    }
    */
}

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

