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
    
    @IBOutlet weak var fakeTitle: UILabel!
    override func viewDidLoad() {
        
        if let tour = tour {
            fakeTitle.text = tour.title
        }
    }
    
}
