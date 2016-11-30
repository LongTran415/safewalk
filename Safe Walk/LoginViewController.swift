//
//  LoginViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/29/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var confirmPassword: UITextField!
  
  // Handles our user login
  @IBAction func login(_ sender: UIButton) {
  }
  
  // Handles the toggle of our form
  @IBAction func changeForm(_ sender: UISegmentedControl) {
    confirmPassword.isHidden = !confirmPassword.isHidden
  }
  
}
