//
//  photosViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 6/4/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
import Foundation
import UIKit

class photoItem: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!       //For displaying the name of the image
    @IBOutlet weak var imageView: UIImageView!  //For displaying the image
}
class photosViewController: UICollectionViewController {
    var images : [UIImage]?
    var imageNames: [String] = []
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        collectionView.delegate = self
        collectionView.dataSource = self
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoItem", for: indexPath) as! photoItem
        cell.name.text =  String(indexPath.row + 1) + "\n" + imageNames[indexPath.row]
    
        cell.imageView.image = images![indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
    }
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
