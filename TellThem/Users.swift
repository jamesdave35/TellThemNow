//
//  Users.swift
//  TellThem
//
//  Created by James Meli on 8/9/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import Foundation
import Firebase


class Users {
    
    var fullName: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var profileUrl: String!
    var userID: String!
    var ref: DatabaseReference!
    var key: String = ""
    
    init(fullName: String, firstName: String, lastName: String, email: String, userID: String, profileUrl: String) {
        self.fullName = fullName
        self.email = email
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.profileUrl = profileUrl
        var ref: DatabaseReference!
        var key: String = ""
    }
    
    init(snapshot: DataSnapshot) {
        
        self.userID = (snapshot.value! as! NSDictionary)["uid"] as! String
        self.email = (snapshot.value! as! NSDictionary)["email"] as! String
        self.fullName = (snapshot.value as! NSDictionary)["fullName"] as! String
        self.firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
        self.lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
        self.profileUrl = (snapshot.value as! NSDictionary)["profileUrl"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
    }
    
    func toAnyObject() -> [String: Any] {
        
        return ["fullName": self.fullName, "firstName": self.firstName, "lastName": self.lastName, "email": self.email, "uid": self.userID, "profileUrl": self.profileUrl]
    }
}
