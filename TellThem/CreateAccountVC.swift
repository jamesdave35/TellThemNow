//
//  CreateAccountVC.swift
//  TellThem
//
//  Created by James Meli on 10/2/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit
import IBAnimatable
import FBSDKLoginKit
import Firebase

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var joinNowButton: AnimatableButton!
    
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var lastNameTextField: AnimatableTextField!
    @IBOutlet weak var firstNameTextField: AnimatableTextField!
    let authService = AuthServices()
    let databaseService = DatabaseServices()
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        joinNowButton.fillColor = UIColor.lightGray
        joinNowButton.isEnabled = false
        handleTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func handleTextFields(){
        
        firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        lastNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        let firstName = firstNameTextField.text!
        let lastName = firstNameTextField.text!
        let password = passwordTextField.text!
        let email = emailTextField.text!
        
        if firstName == ""  {
            joinNowButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            joinNowButton.backgroundColor = UIColor.lightGray
        } else if lastName == "" {
            joinNowButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            joinNowButton.backgroundColor = UIColor.lightGray
        } else if email == "" {
            joinNowButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            joinNowButton.backgroundColor = UIColor.lightGray
        } else if password.characters.count < 6 {
            joinNowButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            joinNowButton.backgroundColor = UIColor.lightGray
        }
        else {
            joinNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            joinNowButton.backgroundColor = UIColor(hexString: "F22C5A")
            joinNowButton.isEnabled = true
        }
    }
    
    func signUpWithFacebook(completion: @escaping (_ success: Bool, _ user: User) -> Void) {
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
                        completion(true, user!)
                        
                        
                    }
                })
            }
        }
    }
    
    @IBAction func joinWithFacebookPressed(_ sender: Any) {
        signUpWithFacebook { (success, user) in
            if success {
                let email = user.email
                let uid = user.uid
                let name = user.displayName
                let profileUrl = user.photoURL?.absoluteString
                let userToSave = Users(fullName: name!, firstName: name!, lastName: name!, email: email!, userID: uid, profileUrl: profileUrl!)
                self.databaseService.saveUserInDatabase(user: userToSave)
                self.performSegue(withIdentifier: "Tab", sender: nil)
                self.databaseService.fetchUserProfile(completion: { (success, username, url) in
                    if success {
                        // self.welcomeVC?.welcomeLabel.text = "Welcome \(username)"
                        
                    }
                })
                
                print("user succesfully saved in database")
            }
        }
    }
    
    @IBAction func joinNowPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SetProfile", sender: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetProfile" {
            let setProfileVC = segue.destination as! SetProfileImageVC
            setProfileVC.firstName = self.firstNameTextField.text!
            setProfileVC.lastName = self.lastNameTextField.text!
            setProfileVC.email = self.emailTextField.text!
            setProfileVC.password = self.passwordTextField.text!
        }
    }
}
