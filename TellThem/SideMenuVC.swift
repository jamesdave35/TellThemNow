//
//  SideMenuVC.swift
//  TellThem
//
//  Created by James Meli on 10/3/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit

class SideMenuVC: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    let databaseService = DatabaseServices()
    override func viewDidLoad() {
        super.viewDidLoad()
       profileImage.layer.cornerRadius = 50
        
        fetchProfileImageAndName()
        tableView.tableFooterView = UIView()
        
    }

    func fetchProfileImageAndName(){
        databaseService.fetchUserProfile { (success, username, url) in
            if success {
                let profileUrl = URL(string: url)
                self.profileImage.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "default"))
                self.nameLabel.text = username
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ToogleSideMenu"), object: nil)
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                NotificationCenter.default.post(name: NSNotification.Name("LogOut"), object: nil)
            } else if indexPath.row == 1 {
                NotificationCenter.default.post(name: NSNotification.Name("Profile"), object: nil)
            } else if indexPath.row == 2 {
                NotificationCenter.default.post(name: NSNotification.Name("Settings"), object: nil)
            }
        }
    }

}
