//
//  LoginVC.swift
//  TellThem
//
//  Created by James Meli on 10/3/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit
import IBAnimatable
import Firebase
import FBSDKLoginKit

class LoginVC: UIViewController {

    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    let dataService = DatabaseServices()
    let authservice = AuthServices()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
    }

    @IBAction func logInPressed(_ sender: Any) {
        
        if let email = emailTextField.text , let password = passwordTextField.text {
            authservice.signInUser(email: email, password: password, completion: { (success) in
                if success {
                    print("user successfully signed in")
                    self.performSegue(withIdentifier: "Tab3", sender: nil)
                    self.dataService.fetchUserProfile(completion: { (success, username, url) in
                        if success {
                            // self.welcomeVC?.welcomeLabel.text = "Welcome \(username)"
                        }
                    })
                }
            })
        }
    }
    
    
    @IBAction func logInWithFacebookPressed(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: self) { (results, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let accessToken = FBSDKAccessToken.current()
                let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
                Auth.auth().signIn(with: credentials, completion: { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: "Tab3", sender: nil)
                        self.dataService.fetchUserProfile(completion: { (success, username, url) in
                            if success {
                                // self.welcomeVC?.welcomeLabel.text = "Welcome \(username)"
                                
                            }
                        })
                        
                        
                    }
                })
                
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
