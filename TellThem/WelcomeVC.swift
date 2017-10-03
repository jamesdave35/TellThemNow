//
//  WelcomeVC.swift
//  TellThem
//
//  Created by James Meli on 8/9/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class WelcomeVC: UIViewController {

  //  @IBOutlet weak var welcomeLabel: UILabel!
    
    var databaseService = DatabaseServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showSignInVC()
      
        
    }
    
    
    
    func showProfile(){
        
    }
    func showSignInVC(){
        
        if Auth.auth().currentUser == nil {
            let getStartedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetStarted") as! GetStartedVC
            getStartedVC.modalTransitionStyle = .crossDissolve
            self.present(getStartedVC, animated: true, completion: nil)
            
        } else {
            databaseService.fetchUserProfile { (success, username, url) in
                if success {
                    
                    self.navigationItem.title = "Welcome \(username)"
                    
                    
                
                }
                
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        print("Running....")
        
        NotificationCenter.default.post(name: NSNotification.Name("ToogleSideMenu"), object: nil)
        
        
    }
    
//    @IBAction func logOutPressed(_ sender: Any) {
//        do {
//            try Auth.auth().signOut()
//            
//        } catch let logoutError {
//            print(logoutError)
//            
//        }
//        let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as! SignInVC
//        signIn.modalTransitionStyle = .crossDissolve
//        self.present(signIn, animated: true, completion: nil)
//    }

}
