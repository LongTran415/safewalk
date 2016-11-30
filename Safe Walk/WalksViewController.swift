//
//  WalksViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/30/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit

class WalksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let addWalkCellIdentifier = "AddWalkCell"
  let magicNumber = 40.0 as CGFloat // !!!: fix later
  let animationDuration = 0.4 as TimeInterval
  
  @IBOutlet weak var form: UIView!
  @IBOutlet weak var formConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideAddWalkForm(animated: false)
  }
  
  //
  // MARK: View Actions
  //
  @IBAction func hideForm() {
    hideAddWalkForm(animated: true)
  }
  
  func hideAddWalkForm(animated: Bool = true) {
    formConstraint.constant = -form.bounds.height - magicNumber
    
    if (animated) {
      UIView.animate(withDuration: animationDuration, animations: {
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func showAddWalkForm(animated: Bool = true) {
    formConstraint.constant = 0

    if (animated) {
      
      UIView.animate(withDuration: animationDuration, animations: {
        self.view.layoutIfNeeded()
      })
    }
  }
  
  
  //
  // MARK: UITableViewDataSource
  //
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: addWalkCellIdentifier)
    
    return cell ?? UITableViewCell()
  }
  
  //
  // MARK: UITableViewDelegate
  //
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // If this is our AddWalk button
    if (indexPath.section == 0 && indexPath.row == 0) {
      self.showAddWalkForm(animated: true)
    }
    
  }
  
}
