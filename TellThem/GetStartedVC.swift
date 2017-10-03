//
//  GetStartedVC.swift
//  TellThem
//
//  Created by James Meli on 10/2/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {

    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageArray = ["background1", "background2", "background3"]
    var labelArray = ["Express what you feel about the people who have influenced you", "Send them gift cards or flowers so they know how you feel about them", "Invite friends to contribute to you expressions"]
    var timer: Timer!
    var updateCounter: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateCounter = 0
        
        
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }

    func updateTimer() {
        
        if updateCounter <= 2 {
            pageControl.currentPage = updateCounter
            
            backgroundImage.image = UIImage(named: imageArray[updateCounter])
            explanationLabel.text = labelArray[updateCounter]
            
            updateCounter = updateCounter + 1
        } else {
            updateCounter = 0
        }
    }

    @IBAction func signInPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "Login", sender: nil)
    }
    @IBAction func signUpPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreateVC", sender: nil)
    }
}
