//
//  photosViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 6/4/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import UIKit

class photoItem: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
}

class photosViewController: UICollectionViewController {


    var images : [UIImage]?
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        collectionView.delegate = self
        collectionView.dataSource = self
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoItem", for: indexPath) as! photoItem
        
        let imageView = UIImageView.init(image: images![indexPath.row])
        
        cell.name.text = "SOME NAME"

        cell.imageView.image = images![indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        
        print("\n\n\nnumber of images \(images?.count) \n\n\n")
        //unwrap the image

        
        
    }
    
}
