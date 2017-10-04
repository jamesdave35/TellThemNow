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
  

}
