//
//  tourInfo.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/28/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.

/*** Initial Programmer::: Dylan Pitts      ***/

import Foundation
import UIKit
class tourInfo: UIViewController {
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //Need to recieve the selected tour information
    var tour: Tour?
    var distance: Double?
    //This will recieve data from the tour list
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ALik
    //*****************************************************************DYLAN
    @IBOutlet weak var TourTitle: UILabel!
    
    @IBOutlet weak var TourImage: UIImageView!

    @IBOutlet weak var TourTime: UILabel!
    
    @IBOutlet weak var TourType: UILabel!
    
    @IBOutlet weak var TourDistance: UILabel!
    
    @IBOutlet weak var TourDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent((tour?.photos[0])!)
            let image    = UIImage(contentsOfFile: imageURL.path)
            self.TourImage.image = image
           // Do whatever you want with the image
        }
        
        TourTitle.text = tour?.title ?? "Not Data"
        TourTime.text = tour?.duration ?? "00.0 Miles"
        TourType.text = tour?.tourType ?? "Walking"
        TourDistance.text = "\(distance)" + "minutes" ?? "0.0 minutes"
        TourDescription.text = tour?.description ?? "Loading"
    }
    //#################################################################PITTS
}
