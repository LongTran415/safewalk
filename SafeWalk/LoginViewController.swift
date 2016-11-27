//
//  LoginViewController.swift
//  SafeWalk
//
//  Created by Long Work on 11/27/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  //
  // MARK: Default Overrides
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupForm()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //
  // MARK: Initial View Setup
  //
  
  private func setupView(){
    self.view.backgroundColor = .lightGray
    self.navigationItem.title = "Login"
  }
  
  private func setupForm(){
    // Create a new view object, lay it out, and add to the page
    //
    // - Creates the view object
    // - Set flag for layout using constraints
    // - Create the constraints
    // - Add to the subview
    // - Add the constraints
    
    
    // Start: Create view objects
    let emailLabel = UILabel()
    let emailInput = UIInputView()
    let passwordLabel = UILabel()
    let passwordInput = UIInputView()
    let loginButton = UIButton(type: .infoDark)
    // End: Create view objects
    
    
    // Start: Configure view objects
    emailLabel.text = "Email"
    passwordLabel.text = "Password"
    
    emailLabel.sizeToFit()
    passwordLabel.sizeToFit()
    // End: Configure view objects
    
    
    // Start: flag for layout constraints
    emailLabel.translatesAutoresizingMaskIntoConstraints = false
    emailInput.translatesAutoresizingMaskIntoConstraints = false
    passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    passwordInput.translatesAutoresizingMaskIntoConstraints = false
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    // End: flag for layout constraints

    
    // Start: Create view constraints
    
    // End: Create view constraints
    
    
    // Start: add to subview
    self.view.addSubview(emailLabel)
    self.view.addSubview(emailInput)
    self.view.addSubview(passwordLabel)
    self.view.addSubview(passwordInput)
    self.view.addSubview(loginButton)
    // End: add to subview

    
    // Start: add constraints to view
    // End: add constraints to view

  }
}
