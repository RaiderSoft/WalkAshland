//
//  AppDelegate.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import UIKit
import Firebase //needed to use firebase platform
import GoogleMaps //For using google maps
import GooglePlaces //To access places, current place

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: COMMENT
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
    var dataModel: DataModel! = DataModel()   //Create an instance of the the datamodel
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-Faisal
        //Connecting to Firebase database
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        //Later Restrict the API key                                        //>>>><<<K<<<<<<#<#<#<#<#<$<$<<#<#<#
        //providing the google maps Api key
        GMSServices.provideAPIKey("AIzaSyDjNpvuv_eW0ogWbHevj3MWwll2El58mW0")
        GMSPlacesClient.provideAPIKey("AIzaSyDjNpvuv_eW0ogWbHevj3MWwll2El58mW0")
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

