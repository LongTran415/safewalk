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
  // MARK: Instance variables
  //

  // View settings
  let formWidth: CGFloat = 350
  let formHeight: CGFloat = 200
  let inputWidth: CGFloat = 200
  let inputPadding: CGFloat = 20
  let rowPadding: CGFloat = 5
  let formPadding: CGFloat = 20
  
  // View objects
  var emailLabel: UILabel { return createFormLabel(text: "Email") }
  let emailInput = UITextField()
  var passwordLabel: UILabel { return createFormLabel(text: "Password") }
  let passwordInput = UITextField()
  let loginButton = UIButton(type: .system)

  // Network
  let networkController = LoginNetworkController()
  
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
  // MARK: View Actions
  //

  func login() {
    /*
      hideView()
      showSpinner()
      makeLoginCall()
      backToMapView()
      changeUserIcon()
   */
    
    // If the user has entered the email & password, attempt to login
    if (emailInput.text?.characters.count)! > 0 && (passwordInput.text?.characters.count)! > 0 {
      networkController.login(email: emailInput.text!, password: passwordInput.text!)
    }
    
  }

  
  //
  // MARK: Initial View Setup
  //
  
  private func setupView(){
    self.view.backgroundColor = .darkGray
    self.navigationItem.title = "Login"
  }
  
  private func setupForm(){
    // Create views
    let bgView = createBackgroundView()
    let formView = createFormView()
    
    // Background View Constraints
    let bgCenterX = NSLayoutConstraint(item: bgView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 1)
    let bgCenterY = NSLayoutConstraint(item: bgView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 1)
    
    // Form View Constraints
    let formWidth = NSLayoutConstraint(item: formView, attribute: .width, relatedBy: .equal, toItem: bgView, attribute: .width, multiplier: 1, constant: 1)
    let formHeight = NSLayoutConstraint(item: formView, attribute: .height, relatedBy: .equal, toItem: bgView, attribute: .height, multiplier: 1, constant: 1)
    let formTopPos = NSLayoutConstraint(item: formView, attribute: .top, relatedBy: .equal, toItem: bgView, attribute: .top, multiplier: 1, constant: 1)
    let formLeftPos = NSLayoutConstraint(item: formView, attribute: .left, relatedBy: .equal, toItem: bgView, attribute: .left, multiplier: 1, constant: 1)
    
    // Add subviews
    bgView.addSubview(formView)
    self.view.addSubview(bgView)
    
    // Add constraints
    bgView.addConstraints([formWidth, formHeight, formTopPos, formLeftPos])
    self.view.addConstraints([bgCenterX, bgCenterY])
  }
  
  
  // 
  // MARK: View Creation Helper functions
  //
  private func createFormLabel(text: String!) -> UILabel {
    let view = UILabel()
    view.text = text
    
    return view
  }
  
  private func createFormRow(views: [UIView]) -> UIStackView {
    let view = UIStackView(arrangedSubviews: views)
    
    view.axis = .horizontal
    view.alignment = .center
    view.distribution = .fill
    view.spacing = inputPadding

    return view
  }
  
  private func createFormView() -> UIView {
    // Style input fields
    styleInputs(views: [emailInput, passwordInput])
    styleLoginButton(view: loginButton)
    
    // Set up our view rows and subviews
    let emailView = createFormRow(views: [emailLabel, emailInput]) as UIView
    let passwordView = createFormRow(views: [passwordLabel, passwordInput]) as UIView
    let subviews = [emailView, passwordView, loginButton]
    
    // Create the StackView
    let formView = UIStackView(arrangedSubviews: subviews)
    formView.layoutMargins = UIEdgeInsetsMake(formPadding, formPadding, formPadding, formPadding)
    formView.translatesAutoresizingMaskIntoConstraints = false
    formView.isLayoutMarginsRelativeArrangement = true
    formView.distribution = .equalSpacing
    formView.axis = .vertical
    formView.spacing = rowPadding

    return formView
  }
  
  private func createBackgroundView() -> UIView {
    // Create a containing view to set a background color
    let bgView = UIView()
    
    bgView.backgroundColor = .lightGray
    bgView.translatesAutoresizingMaskIntoConstraints = false

    let bgWidth = NSLayoutConstraint(item: bgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: formWidth)
    let bgHeight = NSLayoutConstraint(item: bgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: formHeight)
    
    bgView.addConstraints([bgWidth, bgHeight])
    
    return bgView
  }
  
  private func styleInputs(views: [UITextField]){
    for view in views {
      view.backgroundColor = .white

      let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: inputWidth)
      
      view.addConstraint(width)
    }
  }
  
  private func styleLoginButton(view: UIButton){
    view.setTitle("Login", for: .normal)
    view.titleLabel?.font = .boldSystemFont(ofSize: 18.0)
    view.addTarget(self, action: #selector(login), for: .touchUpInside)
  }
  
  
  //
  // MARK: View Action Helper functions
  //

}

