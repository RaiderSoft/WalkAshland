//
//  accountViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import AuthenticationServices
/*
extension accountViewController :  ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            
            let defaults = UserDefaults.standard
            
            defaults.set(userIdentifier, forKey: "userIdentifier")
            
            //Save the userIdentifier somewhere in your server/database
            
            let ID = userIdentifier
            
            self.present(self, animated: true)
            
            break
        default:
            break
            
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

class accountViewController: UIViewController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // actionCodeSettings.url = actionCodeSetting
        // actionCodeSettings.handleCodeInApp = true
        // actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabView = segue.destination as? tabView, let user = sender as? User{
            tabView.user = user
        }
    }
    
    @objc func appleIDButtonTapped(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        
    }


}
 */

