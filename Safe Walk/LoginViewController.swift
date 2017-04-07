//
//  LoginViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/29/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController {

  //
  // MARK: Instance variables
  //

  @IBOutlet weak var emailInput: UITextField!
  @IBOutlet weak var passwordInput: UITextField!
  @IBOutlet weak var confirmPasswordInput: UITextField!

  let networkController = LoginNetworkController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let image = UIImage(named: "Image-2", in: Bundle.main, compatibleWith: nil)
    let newImage = image?.imageScaledToSize(CGSize(width: 1000, height: 700))
    let imageView = UIImageView(image: newImage)
    
    self.view.insertSubview(imageView, at: 0)
  }

  //
  // MARK: View Actions
  //
  
  
  @IBAction func login(_ sender: UIButton) {
    if (emailInput.text?.characters.count)! > 0 && (passwordInput.text?.characters.count)! > 0 {
      
      networkController.login(email: emailInput.text!, password: passwordInput.text!, onSuccess: {
        print("LoginViewController: Login success")
        self.performSegue(withIdentifier: "login", sender: nil)
      }, onFailure: { (errorMessage) in
        print("LoginViewController: Login failure \(errorMessage)")
      })
      
    }
  }
  
  // Handles the toggle of confirmPassword field
  @IBAction func toggleConfirmPassword(_ sender: UISegmentedControl) {
    confirmPasswordInput.isHidden = !confirmPasswordInput.isHidden
  }

}

