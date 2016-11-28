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
  // MARK: Default Overrides
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMapView()
    setupNavigationBar()
    setupWalkButton()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //
  // MARK: View Actions
  //
  
  func presentUserLogin() {
    let loginViewController = LoginViewController()
    self.navigationController?.pushViewController(loginViewController, animated: true)
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
    let button = UIBarButtonItem(title: "Request a Walk", style: .plain, target: nil, action: nil)
    self.navigationController?.setToolbarHidden(false, animated: true)
    self.setToolbarItems([button], animated: true)
  }
}

