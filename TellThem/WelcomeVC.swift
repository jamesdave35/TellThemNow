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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logOut), name: NSNotification.Name("LogOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showProfile), name: NSNotification.Name("Profile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSettings), name: NSNotification.Name("Settings"), object: nil)
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showSignInVC()
    }
    
    func showSignInVC(){
        if Auth.auth().currentUser == nil {
            let getStartedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetStarted") as! GetStartedVC
            getStartedVC.modalTransitionStyle = .crossDissolve
            self.present(getStartedVC, animated: true, completion: nil)
            
        } 
    }
    
    @objc func showProfile(){
        self.performSegue(withIdentifier: "Profile", sender: nil)
    }
    
    @objc func showSettings(){
        self.performSegue(withIdentifier: "Settings", sender: nil)
    }
    @objc func logOut() {
        do {
            try Auth.auth().signOut()
            
        } catch let logoutError {
            print(logoutError)
            
        }
        let getStartedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetStarted") as! GetStartedVC
        getStartedVC.modalTransitionStyle = .crossDissolve
        self.present(getStartedVC, animated: true, completion: nil)
    }
  

    @IBAction func addButtonPressed(_ sender: Any) {
       
        
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ToogleSideMenu"), object: nil)
        
        
    }
    


}
