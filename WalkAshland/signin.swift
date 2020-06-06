//
//  signin.swift
//  WalkAshland
//
//  Created by Faisal Alik on 5/24/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices

class SigninViewController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appleSigninButton = ASAuthorizationAppleIDButton()
        appleSigninButton.translatesAutoresizingMaskIntoConstraints = false
        appleSigninButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        
        view.addSubview(appleSigninButton)
        NSLayoutConstraint.activate([
            appleSigninButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleSigninButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleSigninButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
        
        
        
    }
    @objc func didTapAppleButton (){
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let NVC = segue.destination.children.first as? UINavigationController, let toursVC = NVC.children.first as? toursViewController , let user = sender as? User {
            toursVC.user = user
        }
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
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = User(credentials: credentials)
            
            
            
            
            performSegue(withIdentifier: "segue", sender: user)
            
        default: break 
        }
    }
    
    
}
