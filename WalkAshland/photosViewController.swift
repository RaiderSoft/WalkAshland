//
//  photosViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 6/4/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import UIKit

class photosViewController: UIViewController {
    @IBOutlet weak var photosStack: UIStackView!

    var images : [UIImage]?
    
    override func viewDidLoad() {
        print("\n\n\nnumber of images \(images?.count) \n\n\n")
        //unwrap the image

        if let images = images {
            var stviews : [UIImageView] = []
            for image in images {
                stviews.append(UIImageView.init(image: image))
            }
            for u in stviews {
                photosStack.addArrangedSubview(u)
            }
            print("\(photosStack.arrangedSubviews.count)")
            self.photosStack.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(photosStack)
            
        }
        
    }
}
