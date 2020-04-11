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
        //TourTitle.text = tour?.title
    
    @IBOutlet weak var TourImage: UIImageView!
        //TourImage.image = tour?.imgPath

    @IBOutlet weak var TourTime: UILabel!
        //TourTime.text = tour?.duration
    
    @IBOutlet weak var TourType: UILabel!
        //TourType.text = tour?.tourType
    
    @IBOutlet weak var TourDistance: UILabel!
        //TourDistance.text = tour?.duration
    
    @IBOutlet weak var TourDescription: UILabel!
        //TourDescription.text = tour?.description
    
}
