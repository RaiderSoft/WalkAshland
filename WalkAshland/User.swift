//
//  User.swift
//  WalkAshland
//
//  Created by Faisal Alik on 5/24/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import Foundation
import AuthenticationServices
//This is a user object
struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    //Initialize the user with the given credentials or empty strings
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
        
    }
}
//For debuging purposes
extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        ID: \(id)
        First Name: \(firstName)
        Last Name: \(lastName)
        Email: \(email)
        """
    }
}
