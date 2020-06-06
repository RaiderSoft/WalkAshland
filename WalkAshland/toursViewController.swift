//
//  toursViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
import UIKit
import Firebase     //needed for using Firebase database and referencing the db
import FirebaseUI   //
import SDWebImage   //Needed for using active loading of an image from the firebase storage
import SDWebImageWebPCoder
import SwiftUI
import MapKit
import CoreLocation //For accesing the curent location
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
import StoreKit

extension toursViewController : tourCellDelegate {
        
    /*      In this function we check for user authorization of using the location  >>>>Faisal    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {             //check if the user has given authorization
            locationManager.requestLocation()           //Request the location of user
        }
        else {
            NSLog("COULD not access location")
        }
    }
    /*      In this function we take action for errors from     >>>>Faisal  */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("ERROR:: \(error) ")
    }
    
    func tourCell(_ tourCell: tourCell, msg: String, title: String) {
        
        let alertController = UIAlertController(title: "\(title)", message: "\(msg)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController,animated: true, completion: nil)
    }
}
/*  This class is the class for the tours view controller that list the tours   */
class toursViewController: UITableViewController, CLLocationManagerDelegate{
    
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //Creating variable to be set from the scene delegate for the data
    var dataModel: DataModel?
    //To store dowloaded tours from the model
    var tours: [Tour] {
        return dataModel?.tours ?? []
    }
    var user : User!
    var distance: Double!
    var duration: Double!
    //Create a reference to the firebase storage for accessing files
    let storageRef = Storage.storage().reference()
    let locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    let directionRequest = MKDirections.Request()            //Creating a request of direction
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = dataModel?.user {
            self.user = user
        }
        
        var firstName = ""

         if let result = dataModel?.saveuserinfo(user: user){
            if result {
                if user.firstName != "" {
                    firstName = user.firstName
                }
                else {
                    firstName = "UnknownUser"
                }

                let alertController = UIAlertController(title: "Greeting", message: "Hi \(firstName) \n Thanks for creating an account \n Enjoy.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController,animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Greeting", message: "Hi \n Welcome Back \n Enjoy.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                    action in

                    }))
                self.present(alertController,animated: true, completion: nil)
            }

        }
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            self.locationManager.startUpdatingLocation()
        }

        NSLog("Reached \(user)")
        

        


        
        reloadInputViews()
        loadView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tourinfo", sender: nil)
    }
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This function is called before the view will be loaded
    //I used this function to reload the data on the table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadInputViews()
        loadView()
        
        
    }

    /*  This function updates the user's location      >>>>Faisal */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //  let locationPoints = gets from tour             //Get the location points create annotations
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locValue
        locationManager.stopUpdatingLocation()

        //Set the region where the mapview should focus on
        //Get the longitude and latitude of the centeral point in the
        //tour and set as the center of the camera
        loadView()
        
    }
    //This function sets the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count
    }
    
    
    
    //Settup the contents of a tour dynamically
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        let tour = tours[indexPath.row]             //For each row create a cell  with cell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! tourCell
        
        cell.delegate = self
        //SKPaymentQueue.default().add(cell)
        cell.fetchAvailableProducts()
        //Setup all static images for a cell
        cell.typeImgOut.image = UIImage.init(named: "walking")
        cell.durImgOut.image = UIImage.init(named: "timeicon")
        cell.distImgOut.image = UIImage.init(named: "locationicon")
        
        //Take care of location and distance
        
        //For now [0] later location and photos
        if  let destinationLat = tour.locationPoints[0]["Latitude"],        //latitude of starting point of the location
            let destinationLong = tour.locationPoints[0]["Longitude"],      //longitude 0f /////
            let sourceLong = currentLocation?.longitude                     //longitude of user's curent location
            ,let sourceLat = currentLocation?.latitude                      //latitude of //////
            {                                                               //The source and distenation ofthe requested direction
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLat , longitude: destinationLong)))
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sourceLat , longitude: sourceLong)))
            }
        directionRequest.requestsAlternateRoutes = false                //Set alternative paths to none
        directionRequest.transportType = .walking                       //Default transport type is walking
        let directions = MKDirections(request: directionRequest)        //request a direction from the source to the direction
        directions.calculate { (response, error) in                     //Get an process the respons to the the direction request
            guard let directionResponse = response else {
                if let error = error {
                        NSLog("ERROR: \t Failed on unwrapping response: \(error)")
                }
                return
            }
            let route = directionResponse.routes[0]                     //Get the first posible route
            NSLog("Number of route :  \(directionResponse.routes.count)\n")
            //Foot const
            let toFeet = 3.28084                                        //one meters in feet
            let toMile = 5280.0                                         //one mile in feets
            self.distance = (route.distance * toFeet) / toMile           //distance in miles
            cell.distLabelOut.text = "\( round((self.distance / 0.01 ) * 0.01)) miles away"        //Set the distance label in the view
        }
        //Trim the title to a fitting size
        let t : String = tour.title                                     //These steps are for truncating the title to a file size
        var title = ""
        if t.count > 15 {
            let index = t.index(t.startIndex, offsetBy: 25)
            let ti = t[..<index] 
            for i in ti {
                title = "\(title)\(i)"
            }
            cell.titleOut.text = title                                  //Set the title to the new lenght
        }
        else {
            cell.titleOut.text = tour.title                             //Set the title of the tour
        }
        //Trim the description to a fitting size
        let d : String = tour.description                               //These steps are to truncate the desription to fine size
        var description = ""
        if d.count > 150 {
            let index = d.index(d.startIndex, offsetBy: 150)
            let de = d[..<index]
            for i in de {
                description = "\(description)\(i)"
            }
            cell.aboutOut.text = description    }
        else {
            cell.aboutOut.text = tour.description                       //Set description of the tour
        }
        
        cell.durNumOut.text = "\(tour.duration)"                   //Set the duration of the tour
        
        cell.typeLabelOut.text = tour.tourType                          //Set the type of the tour
        
        /*
            Download the image and view is
            Create a reference to this image from the firebase storage
         */
                
        let documentsDirectoryPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let prevImagePath =  URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(tour.photos[0])
        let image = UIImage(contentsOfFile: prevImagePath.path)
        cell.imgOut.image = image
        cell.startOut.tag = indexPath.row                               //A way to p
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    return cell
    }
    
     //SEND this tour data on clicking
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        if let index = tableView.indexPathForSelectedRow?.row {
            if let tourInfo = segue.destination as? tourInfo {
               tourInfo.tour = tours[index]
            }
        }
        if let playSc = segue.destination as? nplayingViewController {
            if let obj = sender as? UIButton {
                playSc.tour = tours[obj.tag]
                playSc.distanceAway = distance
            }
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }

}


/* Faisal:
   This class handles */
class tourCell: UITableViewCell, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    weak var delegate : tourCellDelegate?
    //let productID = "com.walkashland.walkashland.route2" //productID from appConnect
    var productsRequest = SKProductsRequest()
    var validProducts = [SKProduct]()
    var productIndex = 0
    
    @IBOutlet weak var durImgOut: UIImageView!
    @IBOutlet weak var typeLabelOut: UILabel!
    @IBOutlet weak var typeImgOut: UIImageView!
    @IBOutlet weak var distLabelOut: UILabel!
    @IBOutlet weak var distImgOut: UIImageView!
    
    //This is for the button to be labeled download, start, or purchase (price)
    @IBOutlet weak var PDSButtonOut: UIButton!
    @IBOutlet weak var startOut: UIButton!
    
    @IBOutlet weak var durNumOut: UILabel!
    @IBOutlet weak var imgOut: UIImageView!
    
    @IBOutlet weak var aboutOut: UILabel!
    @IBOutlet weak var titleOut: UILabel!
    
    //@dylan pitts June 2, 2020
    //checks each transaction if the item purchased
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//
//        var productsRequest = SKProductsRequest()
//        var validProducts = [SKProduct]()
//        var productIndex = 0
//
//        PDSButtonOut.isHidden = true
//        startOut.isHidden = true
//
//
//
//
//        //disable purchase button enable start button for each transaction purchased
//        for transaction in transactions {
//            if transaction.transactionState == .purchased {
//                print("Item purchased")
//
//                PDSButtonOut.isEnabled = false
//                PDSButtonOut.isHidden = true
//                startOut.isEnabled = true
//                startOut.isHidden = false
//
//            //if failed do something
//            } else if transaction.transactionState == .failed {
//                print("transaction failed")
//            }
//        }
//    }
    //@dylan pitts June 2, 2020
    //if purchase button prssed
    @IBAction func purchasePressed(_ sender: Any) {
        
        productIndex = 0
        purchaseMyProduct(validProducts[productIndex])
        
        //        //check if user is eligible to make purchase
//        if SKPaymentQueue.canMakePayments() {
//
//            //create payment rquest for a product
//            let paymentRequest = SKMutablePayment()
//            paymentRequest.productIdentifier = productID
//
//            //attempt purchase
//            SKPaymentQueue.default().add(paymentRequest)
//
//        //if user unable to make purchases
//        } else {
//            print("user unable to make payements")
//        }
    }
    
    func fetchAvailableProducts()  {
        let productIdentifiers = NSSet(objects:
            "com.walkashland.walkashland.route2"         // 0
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            validProducts = response.products
                
            let route1 = response.products[0] as SKProduct
            print("1st rpoduct: " + route1.localizedDescription)

        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(_ product: SKProduct) {
        var msg = ""
        var title = ""
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            
            msg = "Purchases are disabled in your device!"
            title = "Transaction Error!"
            
            self.delegate?.tourCell(self, msg: msg, title: title)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        var msg = ""
        var title = ""
        
            for transaction:AnyObject in transactions {
                if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                    switch trans.transactionState {
                        
                    case .purchased:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        if productIndex == 0 {
                            print("You've bought route 1")
                            
                            PDSButtonOut.isEnabled = false
                            PDSButtonOut.isOpaque = true
                            startOut.isEnabled = true
                            startOut.isOpaque = false
                        } else {
                           //other purchase
                        }
                        break
                        
                    case .failed:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        
                        msg = "Payment has failed."
                        title = "Transaction Error!"
                        
                        self.delegate?.tourCell(self, msg: msg, title: title)
                        
                        break
                    case .restored:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        print("Purchase has been successfully restored!")
                        break
                        
                    default: break
            }}}
    }
    
    func restorePurchase() {
            SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
            SKPaymentQueue.default().restoreCompletedTransactions()
    }
        
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
            
        let msg = "Purchase Completed."
        let title = "Transaction Success!"
        
        self.delegate?.tourCell(self, msg: msg, title: title)
    }
}

protocol tourCellDelegate: AnyObject {
    func tourCell(_ tourCell: tourCell, msg: String, title: String)
}
