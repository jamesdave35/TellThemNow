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
import CFAlertViewController


class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    let dataService = DatabaseServices()
    let authservice = AuthServices()
    let color = UIColor(hexString: "F2105A")
    
    @IBOutlet weak var loginButton: AnimatableButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        activityIndicator.isHidden = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.fillColor = UIColor.lightGray
        loginButton.isEnabled = false
        handleTextFields()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func handleTextFields(){
        
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        let password = passwordTextField.text!
        let email = emailTextField.text!
        
        if  email == "" {
            loginButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            loginButton.backgroundColor = UIColor.lightGray
        } else if password.characters.count < 6 {
            loginButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            loginButton.backgroundColor = UIColor.lightGray
        } else {
            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            loginButton.backgroundColor = UIColor(hexString: "F22C5A")
            loginButton.isEnabled = true
        }
    }
    

    @IBAction func logInPressed(_ sender: Any) {
        loginButton.setTitle("", for: UIControlState.normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if let email = emailTextField.text , let password = passwordTextField.text {
            authservice.signInUser(email: email, password: password, completion: { (success, error) in
                if success {
                    print("user successfully signed in")
                    self.performSegue(withIdentifier: "Tab3", sender: nil)
                    self.dataService.fetchUserProfile(completion: { (success, username, url) in
                        if success {
                            // self.welcomeVC?.welcomeLabel.text = "Welcome \(username)"
                        }
                    })
                } else if !success{
                    self.loginButton.setTitle("LOG IN", for: UIControlState.normal)
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    let alertView: CFAlertViewController = CFAlertViewController(title: "Sorry", titleColor: UIColor(hexString: "F52757"), message: error?.localizedDescription, messageColor: UIColor.black, textAlignment: .center, preferredStyle: .alert, headerView: nil, footerView: nil, didDismissAlertHandler: nil)
                    let action: CFAlertAction = CFAlertAction(title: "Dismiss", style: .Default, alignment: .justified, backgroundColor: self.color, textColor: UIColor.white, handler: nil)
                    
                    alertView.addAction(action)
                    self.present(alertView, animated: true, completion: nil)
                    
                    
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
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
//        let alertView: CFAlertViewController = CFAlertViewController(title: "Enter your email", titleColor: UIColor.black, message: "", messageColor: UIColor.black, textAlignment: .center, preferredStyle: .alert, headerView: nil, footerView: nil, didDismissAlertHandler: nil)
        
        
    }
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
