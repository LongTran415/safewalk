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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //
  // MARK: Initial View Setup
  //
  
  private func setupMapView() {
    // create map view object
    let mapView = MKMapView()
    
    // allow layout using constraints
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
    let loginButton = UIBarButtonItem(image: loginImage, style: .plain, target: nil, action: nil)
    self.navigationItem.rightBarButtonItem = loginButton
  }
}

