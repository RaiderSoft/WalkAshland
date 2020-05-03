//
//  tourInfo.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/28/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import UIKit
class tourInfo: UIViewController {
    
    var tour: Tour?
    
    @IBOutlet weak var TourTitle: UILabel!
    
    @IBOutlet weak var TourImage: UIImageView!

    @IBOutlet weak var TourTime: UILabel!
    
    @IBOutlet weak var TourType: UILabel!
    
    @IBOutlet weak var TourDistance: UILabel!
    
    @IBOutlet weak var TourDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // get image from directory
               let path = "/ashland1.jpeg"
               guard   let img = UIImage(named: "ashland1"),
                       let url = img.save(at: .documentDirectory,
                                          pathAndImageName: path) else { return }
               
               guard let img2 = UIImage(fileURLWithPath: url) else { return }
        
        TourTitle.text = "Plaza" //tour?.title
        TourImage.image = img2
        TourTime.text = "23 mins" //tour?.duration
        TourType.text = "Walking" //tour?.tourType
        TourDistance.text = "500 ft" //tour?.duration
        TourDescription.text = "This is a test Discription" //tour?.description

    }
    
}
