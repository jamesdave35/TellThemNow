//
//  ContainerVC.swift
//  TellThem
//
//  Created by James Meli on 10/3/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {

    @IBOutlet weak var slideConstraint: NSLayoutConstraint!
    var sideMenuVisible = false
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.toogleSideMenu), name: NSNotification.Name("ToogleSideMenu"), object: nil)
        
    }

   @objc func toogleSideMenu() {
        if sideMenuVisible {
            slideConstraint.constant = -240
            sideMenuVisible = false
        } else {
            slideConstraint.constant = 0
            sideMenuVisible = true
        }
    }

}
