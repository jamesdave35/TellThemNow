//
//  TabBarVC.swift
//  TellThem
//
//  Created by James Meli on 8/29/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit
import Firebase

class TabBarVC: UITabBarController {
    
    let databaseService = DatabaseServices()

    override func viewDidLoad() {
        super.viewDidLoad()

       showSignInVC()
    }
    func showSignInVC(){
        
        if Auth.auth().currentUser == nil {
            let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as! SignInVC
            signIn.modalTransitionStyle = .crossDissolve
            self.present(signIn, animated: true, completion: nil)
            
        } else {
            databaseService.fetchUserProfile { (success, username, url) in
                if success {
                    //self.welcomeLabel.text = "Welcome \(username)"
                }
                
            }
        }
    }
  

}
