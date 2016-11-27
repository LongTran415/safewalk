//
//  ViewController.swift
//  SafeWalk
//
//  Created by Long Work on 11/26/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
import MapKit

class RootViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    createMapView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func createMapView() {
    // create map view object
    let mapView = MKMapView()
    
    // allow layout using constraints
    mapView.translatesAutoresizingMaskIntoConstraints = false
    
    let widthConstraint = NSLayoutConstraint(item: mapView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 1)
    let heightConstraint = NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 1)
    
    self.view.addSubview(mapView)
    self.view.addConstraints([widthConstraint, heightConstraint])
  }
}

