//
//  DatabaseServices.swift
//  TellThem
//
//  Created by James Meli on 8/9/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import Foundation
import Firebase


class DatabaseServices {
    
    var ref: DatabaseReference?
    
    
    func saveUserInDatabase(user: Users) {
        
        ref = Database.database().reference(fromURL: "https://tellthemnow-4bf4d.firebaseio.com/")
        let userRef = ref?.child("users").child(user.userID)
        userRef?.setValue(user.toAnyObject())
    }
    
    func fetchUserProfile(completion: @escaping(_ success: Bool, _ profileName: String, _ profileUrl: String) -> Void){
        
        if let uid = Auth.auth().currentUser?.uid {
         let userRef = Database.database().reference().child("users").child(uid)
        
          userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            
            let dict = snapshot.value as! [String: AnyObject]
            let username = dict["fullName"] as! String
            let url = dict["profileUrl"] as! String
            
            completion(true, username, url)
        })
    }
    }
}
