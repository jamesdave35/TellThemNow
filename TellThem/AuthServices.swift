//
//  AuthServices.swift
//  TellThem
//
//  Created by James Meli on 8/9/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class AuthServices {
    
    func createUser(email: String, password: String, completion: @escaping (_ success: Bool, _ user: User) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                completion(true, user!)
            }
        }
    }
    
    
    func signInUser(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("\(error!.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
        
        
    }
    
    
    
    
}
