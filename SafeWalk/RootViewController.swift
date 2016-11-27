//
//  RootViewController.swift
//  SafeWalk
//
//  Created by Long Work on 11/26/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupInitialViewControllers()
    setupNavigationBar()
  }
  
  override func didReceiveMemoryWarning() {
    // clean up if needed
  }
  
  private func setupInitialViewControllers() {
    // create mapViewcontroller
    // put in viewController
    let mapViewController = MapViewController()
    self.viewControllers = [mapViewController]
  }
  
  private func setupNavigationBar() {
    self.navigationBar.barStyle = .blackTranslucent
  }

}
