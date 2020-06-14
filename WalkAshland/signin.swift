//
//  signin.swift
//  WalkAshland
//
//  Created by Faisal Alik on 5/24/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
import Foundation
import UIKit
import AuthenticationServices
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
class SigninViewController: UIViewController{
    
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        let documentsPhotoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //create a reference to the file
        let lcdb = "walkashland.wadb"
        let localFile = documentsPhotoURL.appendingPathComponent(lcdb)
        
//        let userInfo = 
        
        let appleSigninButton = ASAuthorizationAppleIDButton()
        appleSigninButton.translatesAutoresizingMaskIntoConstraints = false
        appleSigninButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        view.addSubview(appleSigninButton)
        NSLayoutConstraint.activate([
            appleSigninButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleSigninButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleSigninButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
    @objc func didTapAppleButton (){
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        
        if let TVC = segue.destination as? TabBarViewController , let user = sender as? User {
            TVC.user = user     //send the user info to the tabview controller
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }
}
extension SigninViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        NSLog("\(error)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let usr = User(credentials: credentials)
            self.user = usr    //Set the user in this class to the user.
            let sv = usr.saveToLocalDb  //Write this to a local db

            let documentsPhotoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //create a reference to the file
            let lcdb = "walkashland.wadb"
            var localFile = documentsPhotoURL.appendingPathComponent(lcdb)

            //get firestore reference for the image
            do {
                
                try sv.write(to: localFile, atomically: true, encoding: .ascii)
            }
            catch{
                //print("Error Writing user to the localdb")
            }
            
            
            performSegue(withIdentifier: "segue", sender: usr) //perform a segue
            
        default: break 
        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
    }

}
