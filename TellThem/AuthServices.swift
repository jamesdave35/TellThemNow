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
import CFAlertViewController


class AuthServices {
    
    func createUser(email: String, password: String, completion: @escaping (_ success: Bool, _ user: User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(false, nil)
                
            } else {
                completion(true, user!)
            }
        }
    }
    
    
    func signInUser(email: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("\(error!.localizedDescription)")
                
                completion(false, error!)
            } else {
                completion(true, nil)
            }
        }
        
        
    }
    
    
    
    
}
