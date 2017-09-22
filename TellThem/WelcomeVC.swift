//
//  WelcomeVC.swift
//  TellThem
//
//  Created by James Meli on 8/9/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {

  //  @IBOutlet weak var welcomeLabel: UILabel!
    var databaseService = DatabaseServices()
    let profileImage = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        showSignInVC()
        profileImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 30
        profileImage.contentMode = .scaleAspectFill
        
        profileImage.image = UIImage(named: "default")
        
        let barButton = UIBarButtonItem(image: profileImage.image, style: .done, target: self, action: #selector(self.showProfile))
        navigationItem.leftBarButtonItem = barButton
       
        
    }
    
    func showProfile(){
        
    }
    func showSignInVC(){
        
        if Auth.auth().currentUser == nil {
            let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as! SignInVC
            signIn.modalTransitionStyle = .crossDissolve
            self.present(signIn, animated: true, completion: nil)
            
        } else {
            databaseService.fetchUserProfile { (success, username) in
                if success {
                    //self.welcomeLabel.text = "Welcome \(username)"
                }
                
            }
        }
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
