//
//  DismissKeyboard.swift
//  TellThem
//
//  Created by James Meli on 8/9/17.
//  Copyright © 2017 James Meli. All rights reserved.
//


import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
