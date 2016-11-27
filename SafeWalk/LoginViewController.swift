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
  let formMinWidth: CGFloat = 200
  let formMaxWidth: CGFloat = 300
  let formHeight: CGFloat = 200
  
  var emailLabel: UILabel { return createFormLabel(text: "Email") }
  let emailInput = UIInputView()
  var passwordLabel: UILabel { return createFormLabel(text: "Password") }
  let passwordInput = UIInputView()
  let loginButton = UIButton(type: .infoDark)

  
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
  // MARK: Helper functions
  //
  private func createFormLabel(text: String!) -> UILabel {
    let view = UILabel()
    view.text = text
    view.sizeToFit()
    
    return view
  }
  
  private func createFormRow(views: [UIView]) -> UIStackView {
    let view = UIStackView(arrangedSubviews: views)
    
    view.distribution = .equalSpacing
    view.axis = .horizontal
    view.spacing = 5.0
    
    return view
  }
  
  private func createFormView() -> UIView {
    // Set up our view rows and subviews
    let emailView = createFormRow(views: [emailLabel, emailInput]) as UIView
    let passwordView = createFormRow(views: [passwordLabel, passwordInput]) as UIView
    let subviews = [emailView, passwordView, loginButton]
    
    // Create the StackView
    let formView = UIStackView(arrangedSubviews: subviews)
    formView.translatesAutoresizingMaskIntoConstraints = false
    formView.distribution = .equalSpacing
    formView.axis = .vertical
    formView.spacing = 5.0

    return formView
  }
  
  private func createBackgroundView() -> UIView {
    // Create a containing view to set a background color
    let bgView = UIView()
    bgView.backgroundColor = .lightGray
    bgView.translatesAutoresizingMaskIntoConstraints = false

    let bgMinWidth = NSLayoutConstraint(item: bgView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: formMinWidth)
    let bgMaxWidth = NSLayoutConstraint(item: bgView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: formMaxWidth)
    let bgHeight = NSLayoutConstraint(item: bgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: formHeight)
    
    bgView.addConstraints([bgMinWidth, bgMaxWidth, bgHeight])
    
    return bgView
  }
}





