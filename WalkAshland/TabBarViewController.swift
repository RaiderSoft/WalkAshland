//
//  TabBarViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 5/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
    var dataModel: DataModel! = DataModel()   //Create an instance of the the datamodel
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nvc = children.first?.children.first as? toursViewController {
            nvc.dataModel = dataModel
            dataModel.retrieve_data()
        }
        
    }//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
}
