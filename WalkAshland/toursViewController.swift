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

import StoreKit //For purchasing DYLAN

extension toursViewController {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    /*      In this function we check for user authorization of using the location  >>>>Faisal    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if status != .authorizedWhenInUse {             //check if the user has given authorization
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
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
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
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        if let user = dataModel?.user {
            self.user = user
            NSLog("\(user.id)")
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
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                    action
                    in
                    self.reloadInputViews()
                    self.loadView()
                }))
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
        self.reloadInputViews()
        self.loadView()
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        performSegue(withIdentifier: "tourinfo", sender: nil) //Got to the tourinfo view controller
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    //This function is called before the view will be loaded
    //I used this function to reload the data on the table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        self.reloadInputViews()
        self.loadView()      //Reload the view
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
        
    }

    /*  This function updates the user's location      >>>>Faisal */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locValue
        locationManager.stopUpdatingLocation()
        self.reloadInputViews()
        self.loadView()
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
        
    }
    //This function sets the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        return tours.count  //Set the number of rows visible
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
    
    
    //Settup the contents of a tour dynamically
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        let tour = tours[indexPath.row]             //For each row create a cell  with cell class
        NSLog("The product Id will be \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! tourCell
        //Setup all static images for a cell
        cell.typeImgOut.image = UIImage.init(named: "walking")
        cell.durImgOut.image = UIImage.init(named: "timeicon")
        cell.distImgOut.image = UIImage.init(named: "locationicon")
        cell.distImgOut.image = UIImage.init(named: "tolisten")
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
        //################################################################PITTS
        //SKPaymentQueue.default().add(cell)
        cell.fetchAvailableProducts()
        //****************************************************************DYlan
        
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
        cell.dataModel = dataModel
        cell.tourId = indexPath.row
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
            }}
        if let playSc = segue.destination as? nplayingViewController {
            if let obj = sender as? UIButton {
                playSc.tour = tours[obj.tag]
                playSc.distanceAway = distance
            }}
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
}


/* Faisal:
   This class handles */
class tourCell: UITableViewCell, SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
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
    
    var dataModel: DataModel?
    //To store dowloaded tours from the model
    var tours: [Tour] {
        return dataModel?.tours ?? []
    }
    var tourId: Int?

    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    
    
    //****************************************************************DYlan
    weak var delegate : tourCellDelegate?       //alerts
    //let productID = "com.walkashland.walkashland.route2" //productID from appConnect
    var productsRequest = SKProductsRequest()       //retrieve info from app store about list of products
    var validProducts = [SKProduct]()               //get list of products from app store
    var productIndex = 0                            //product index
    
    @IBAction func purchasedPressed(_ sender: UIButton) {

        NSLog("pressed")
        if self.PDSButtonOut.titleLabel?.text != "Download" {
            productIndex = 0
            purchaseMyProduct(validProducts[productIndex])
        } else {
            // MARK: TODO if button is labled download
            // button will now be used to download tour
        }
    }
    //fetch list of available products using product idententifer
    // MARK: TODO make this dynamic
    func fetchAvailableProducts()  {
        
        let productIdentifiers = NSSet(objects:
            "com.walkashland.walkashland.route3"         // 0
        )
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    //responds with list of valid products
    // MARK: TODO print all valid products with a loop
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            validProducts = response.products
            
            //must be on the main thread
            //set title of button to price of route
            DispatchQueue.main.async {
                self.PDSButtonOut.setTitle("\(self.validProducts[self.productIndex].localizedPrice)", for: .normal)
                self.PDSButtonOut.setTitleColor(.white, for: .normal)
            }
            
            print("\(validProducts[productIndex].localizedPrice)")
            let route1 = response.products[0] as SKProduct
            print("1st rpoduct: " + route1.localizedDescription)
        }
    }
    //queue transaction request
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    //checks if user elligible to make payments if true return true
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    //attempt to make payment
    func purchaseMyProduct(_ product: SKProduct) {
        
        var msg = ""
        var title = ""
        
        //can make payments
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
        //can not make payments
        } else {
            
            msg = "Purchases are disabled in your device!"
            title = "Transaction Error!"
            
            self.delegate?.tourCell(self, msg: msg, title: title)
        }
    }
    //check state if transaction
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        var msg = ""
        var title = ""
        
            //for all transactions in the queue
            for transaction:AnyObject in transactions {
                if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                    //check transaction state
                    switch trans.transactionState {
                    //transaction completed
                    case .purchased:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
                        if let user = dataModel?.user {
                            dataModel?.savePurchase(user: user, tour: tourId! )
                            dataModel?.getPurchasedFor(userId: user.id, tours: dataModel!.tours)
                        }
                        self.PDSButtonOut.titleLabel?.text = "Download"
                        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
                        if productIndex == 0 {
                            print("You've bought route 1")
                            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
                            if let user = dataModel?.user {
                                dataModel?.savePurchase(user: user, tour: tourId! )
                                dataModel?.getPurchasedFor(userId: user.id, tours: dataModel!.tours)
                            }
                            //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-Alik
                            
                        } else {
                           //other purchase
                        }
                        break
                        
                    //transaction failed
                    case .failed:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        
                        msg = "Payment has failed."
                        title = "Transaction Error!"
                        
                        self.delegate?.tourCell(self, msg: msg, title: title)
                        
                        break
                        
                    //restoring transaction
                    case .restored:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        print("Purchase has been successfully restored!")
                        break
                        
                    //transaction stuck on purchasing
                    case .purchasing:
                        
                        print("purchasing")
                        
                        msg = "Payment is Processing please wait a moment!."
                        title = "Transaction!"
                        
                        self.delegate?.tourCell(self, msg: msg, title: title)
                        break
                        
                    //transaction deffered
                    case .deferred:
                        print("deferred")
                        break
                        
                    default: break
            }}}
    }
    
    //restore purchase (no corresponding button at the moment)
    // MARK: TODO implement a restore button
    func restorePurchase() {
            SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
            SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //transaction completed successfully
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
            
        let msg = "Purchase Completed."
        let title = "Transaction Success!"

        
        self.delegate?.tourCell(self, msg: msg, title: title)
    }
    //################################################################PITTS
}

 
//****************************************************************DYlan
//alert
extension toursViewController : tourCellDelegate {
        
    func tourCell(_ tourCell: tourCell, msg: String, title: String) {
        
        let alertController = UIAlertController(title: "\(title)", message: "\(msg)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController,animated: true, completion: nil)
    }
}
protocol tourCellDelegate: AnyObject {
    func tourCell(_ tourCell: tourCell, msg: String, title: String)
}

//get price of a route
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
//################################################################PITTS
