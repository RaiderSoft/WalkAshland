//
//  playingViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 4/10/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import AVFoundation

class playingViewController: UIViewController,
    UIPickerViewDataSource, UIPickerViewDelegate{
    
    //This is the initial starting point for the tour
    //var placesClient: GMSPlacesClient!
    
    //Created by Dylan
    //The audio player
    var audioPlayer = AVAudioPlayer()
    
    //List Text for drop down(PickerTextView)
    var audioList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 42.1972 , longitude: 122.7153, zoom: 9.0)
        let mapView = GMSMapView.map(withFrame: self.view.subviews.first?.frame ?? self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        //placesClient = GMSPlacesClient.shared()


       //Created by Dylan
       //bring mediabar forward
       MediaBar.layer.zPosition = 1;
       
       //Do - try - catch audio player for file sample.wav
       do {
           audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Find_Money", ofType: "mp3")!))
           
       } catch {
           print(error)
       }
        
        //mapView.settings.setAllGesturesEnabled(false)
        //used for Drop down menu(PickerTextView)
        self.PickerTextView.delegate = self
        self.PickerTextView.dataSource = self
        
        //text for Drop down menu(PickerTextView)
        audioList = ["Track 1", "Track 2", "Track 3"]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //number of components in the drop down(PickerTextView)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows for drop down(PickerTextView)
    //equal to the amount of elements in audiolist
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return audioList.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        PickerTextView.text = audioList[row]
//    }
    
    //Names of the elements in drop down(PickerTextView) equal to elements in audioList
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return audioList[row]
    }
    //Created By Dylan
    //audio player outlets and actions
    //media tool bar
    @IBOutlet weak var MediaBar: UIToolbar!

    //play
    @IBAction func Play(_ sender: Any) {
        audioPlayer.play()
    }
    //pause
    @IBAction func Pause(_ sender: Any) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    //rewind
    @IBAction func Rewind(_ sender: Any) {
    }
    //fastforward
    @IBAction func FastForward(_ sender: Any) {
    }
    
    //Drop Down Menu
    @IBOutlet weak var PickerTextView: UIPickerView!
    
    //Action For displaying Drop Down Menu
    @IBAction func DisplayList(_ sender: Any) {
                
        //if enable disable and if disable enable on click
        if PickerTextView.layer.zPosition == 0 {
            PickerTextView.isUserInteractionEnabled = true
            PickerTextView.layer.zPosition = 1
        } else {
            PickerTextView.isUserInteractionEnabled = false
            PickerTextView.layer.zPosition = 0
        }
    }
    
    @IBOutlet weak var ViewForMap: UIView!
}
