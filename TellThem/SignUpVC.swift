//
//  SignUpVC.swift
//  TellThem
//
//  Created by James Meli on 8/9/17.
//  Copyright © 2017 James Meli. All rights reserved.
//

import UIKit
import IBAnimatable
import FBSDKLoginKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var hideView: AnimatableView!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var lastNameTextField: AnimatableTextField!
    @IBOutlet weak var firstNameTextField: AnimatableTextField!
     let authService = AuthServices()
    let databaseService = DatabaseServices()
    var welcomeVC: WelcomeVC?
    override func viewDidLoad() {
        super.viewDidLoad()

       hideKeyboardWhenTappedAround()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showPickerController))
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func showPickerController() {
        
        //Initialize an image picker controller
        let imagePickerController = UIImagePickerController()
        
        //Initialize an alertview to prompt to the user on how to choose his profile picture
        let alertController = UIAlertController(title: NSLocalizedString("Add a Picture", comment: "add"), message: NSLocalizedString("Choose From", comment: "message"), preferredStyle: .actionSheet)
        //Initialize 4 actions for the different ways in which the user can choose his profile image
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: NSLocalizedString("Photos Library", comment: "photos"), style: .default) { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: NSLocalizedString("Saved Photos Album", comment: "direction"), style: .default) { (action) in
            imagePickerController.sourceType = .savedPhotosAlbum
            self.present(imagePickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "dismiss"), style: .destructive, handler: nil)
        
        //Add the actions to the alert view controller
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        //Present the alert view from the navigation rightBarButtom item on iPad
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        
        //Present the alertView on iPhone or iPod
        present(alertController, animated: true, completion: nil)
        
        
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        profileImage.image = selectedImage
        widthConstraint.constant = 100
        heightConstraint.constant = 100
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        hideView.isHidden = true
        
        
       
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }


    @IBAction func signUpPressed(_ sender: Any) {
        if firstNameTextField.text != "" && lastNameTextField.text != "" && emailTextField.text != nil && emailTextField.text != nil {
            authService.createUser(email: emailTextField.text!, password: passwordTextField.text!, completion: { (success, user) in
                if success {
                    let uid = user.uid
                    let fullName = "\(self.firstNameTextField.text!) \(self.lastNameTextField.text!)"
                    
                    let storageRef = Storage.storage().reference().child("profile_image").child("\(uid).jpeg")
                    
                    let data = UIImageJPEGRepresentation(self.profileImage.image!, 0.3)
                    storageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error?.localizedDescription)
                        } else {
                            let profileUrl = metadata?.downloadURL()?.absoluteString
                            let userToSave = Users(fullName: fullName, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, email: self.emailTextField.text!, userID: uid, profileUrl: profileUrl!)
                            
                            
                            
                            self.databaseService.saveUserInDatabase(user: userToSave)
                            self.performSegue(withIdentifier: "Tabbar", sender: nil)
                            self.databaseService.fetchUserProfile(completion: { (success, username) in
                                if success {
                                   // self.welcomeVC?.welcomeLabel.text =  "Welcome \(username)"
                                }
                            })
                        }
                    })
                    
                   
                    
                    print("Successfully created user and saved in database")
                }
            })
            
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

    @IBAction func facebookPressed(_ sender: Any) {
        
        signUpWithFacebook { (success, user) in
            if success {
                let email = user.email
                let uid = user.uid
                let name = user.displayName
                let profileUrl = user.photoURL?.absoluteString
                let userToSave = Users(fullName: name!, firstName: name!, lastName: name!, email: email!, userID: uid, profileUrl: profileUrl!)
                self.databaseService.saveUserInDatabase(user: userToSave)
                self.performSegue(withIdentifier: "Tabbar", sender: nil)
                self.databaseService.fetchUserProfile(completion: { (success, username) in
                    if success {
                       // self.welcomeVC?.welcomeLabel.text = "Welcome \(username)"
                    }
                })
                
                print("user succesfully saved in database")
            }
        }
    }
    
    
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}
