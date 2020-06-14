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
    var user : User?
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
    override func viewDidLoad() {
        super.viewDidLoad()
        //Retreive public data
        dataModel.retrieve_data()
        //Get store user information and download purchased items
        
        if let user = user {
            dataModel.user = user
           
        }
            
        else {
            //alert
        }
        if let nvc = children.first?.children.first as? toursViewController {
            nvc.dataModel = dataModel
        }
        if let avc = children.last?.children.last as? accountViewController {
            
            avc.dataModel = dataModel
        }

    }//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
    
}
