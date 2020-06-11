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
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    var saveToLocalDb: String {
        return id + ":" + firstName + ":" + lastName + ":" + email
    }
    //Initialize the user with the given credentials or empty strings
    init(credentials: ASAuthorizationAppleIDCredential) {
        //Fire base does not allow chillds to have . , [ , ], #
        var uId : String = ""
        for var i in credentials.user {
            
            if i == "." {
                i = "!"
            }
            uId = uId + String(i)
        }
        self.id = uId
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
        
    }
    var saveUserDetail: [String: String] {
    //This return the jason formated of the a user data
        return [
        "email" :"\(email)",
        "firstname": "\(firstName)",
        "lastname": "\(lastName)",

        ]
    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
}
//For debuging purposes
extension User: CustomDebugStringConvertible {
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Faisal
    var debugDescription: String {
        return """
        ID: \(id)
        First Name: \(firstName)
        Last Name: \(lastName)
        Email: \(email)
        """
    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Alik
}
