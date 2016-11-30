//
//  MapViewController.swift
//  SafeWalk
//
//  Created by Long Work on 11/26/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  //
  // MARK: Instance Variables
  //
  
  let walkFormHeight = 350.0 as CGFloat
  
  var walkFormConstraint: NSLayoutConstraint?
  
  var walkAddress: UITextField?
  
  var walkDate: UIDatePicker?
  
  let networkController = MapNetworkController()


  //
  // MARK: Default Overrides
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMapView()
    setupNavigationBar()
    setupWalkButton()
    setupWalkForm()
    zoomToCurrentLocation()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setToolbarHidden(false, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    dismissWalkForm()
    self.navigationController?.setToolbarHidden(true, animated: true)
  }
  
  //
  // MARK: View Actions
  //
  
  func presentUserLogin() {
    let loginViewController = LoginViewController()
    self.navigationController?.pushViewController(loginViewController, animated: true)
    self.navigationController?.setToolbarHidden(true, animated: true)
  }

  func presentWalkForm() {
    self.navigationController?.setToolbarHidden(true, animated: true)
    self.walkFormConstraint?.constant = 0.0
    
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  func dismissWalkForm() {
    self.navigationController?.setToolbarHidden(false, animated: true)
    self.walkFormConstraint?.constant = -walkFormHeight

    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  func submitWalkForm() {
    
    if let address = walkAddress?.text {
      if let date = walkDate?.date {
        networkController.submitWalk(address: address, date: date)
        dismissWalkForm()
      }
    }
  }
  
  func zoomToCurrentLocation() {
    LocationManager.shared.manager?.startMonitoringSignificantLocationChanges()
  }
  
  //
  // MARK: Initial View Setup
  //
  
  private func setupMapView() {
    // Create a new view object, lay it out, and add to the page
    //
    // - Creates the map view object
    // - Set flag for layout using constraints
    // - Create the constraints
    // - Add to the subview
    // - Add the constraints
    //
    let mapView = MKMapView()
    
    // Configure the mapView
    mapView.setUserTrackingMode(.follow, animated: true)
    
    mapView.translatesAutoresizingMaskIntoConstraints = false
    
    let widthConstraint = NSLayoutConstraint(item: mapView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 1)
    let heightConstraint = NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 1)
    
    self.view.addSubview(mapView)
    self.view.addConstraints([widthConstraint, heightConstraint])
  }
  
  private func setupNavigationBar() {
    // Add login button
    //
    // - load ui image
    // - add to ui image view
    // - add to bar
    let loginImage = UIImage(named: "login")
    let loginButton = UIBarButtonItem(image: loginImage, style: .plain, target: self, action: #selector(presentUserLogin))
    self.navigationItem.rightBarButtonItem = loginButton
  }
  
  private func setupWalkButton() {
    let button = UIBarButtonItem(title: "Request a Walk", style: .plain, target: self, action: #selector(presentWalkForm))
    self.setToolbarItems([button], animated: true)
  }
  
  private func setupWalkForm() {
    let walkForm = createWalkForm()
    let widthConstraint = NSLayoutConstraint(item: walkForm, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 1)
    self.walkFormConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: walkForm, attribute: .bottom, multiplier: 1, constant: -walkFormHeight)
    
    self.view.addSubview(walkForm)
    self.view.addConstraints([widthConstraint, walkFormConstraint!])
  }
  
  private func createWalkForm() -> UIView {
    
    let formPadding = 20 as CGFloat
    let input = UITextField()
    let date = UIDatePicker()
    let submit = UIButton(type: .roundedRect)
    let cancel = UIButton(type: .roundedRect)
    let form = UIStackView(arrangedSubviews: [input, date, submit, cancel])
    let blurEffect = UIBlurEffect(style: .light)
    let view = UIVisualEffectView(effect: blurEffect)
    
    // Configure Input
    walkAddress = input
    input.placeholder = "Address"
    input.backgroundColor = UIColor.white
    
    // Configure Date
    walkDate = date
    date.datePickerMode = .dateAndTime
    
    // Configure Submit
    submit.setTitle("Submit", for: .normal)
    submit.addTarget(self, action: #selector(submitWalkForm), for: .touchUpInside)
    
    // Configure Cancel
    cancel.setTitle("Cancel", for: .normal)
    cancel.addTarget(self, action: #selector(dismissWalkForm), for: .touchUpInside)
    
    // Configure Form
    form.axis = .vertical
    form.alignment = .fill
    form.distribution = .equalSpacing
    form.translatesAutoresizingMaskIntoConstraints = false
    form.layoutMargins = UIEdgeInsetsMake(formPadding, formPadding, formPadding, formPadding)
    form.isLayoutMarginsRelativeArrangement = true
    
    let formHeightConstraint = NSLayoutConstraint(item: form, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: walkFormHeight)
    let formWidthConstraint = NSLayoutConstraint(item: form, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 1)
    let formBottomConstraint = NSLayoutConstraint(item: form, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 1)
    form.addConstraint(formHeightConstraint)
    
    // Configure view
    view.translatesAutoresizingMaskIntoConstraints = false
    
    let viewHeightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: walkFormHeight)
    
    view.addSubview(form)
    view.addConstraints([viewHeightConstraint, formWidthConstraint, formBottomConstraint])
    
    return view
  }
  
  
  
}

