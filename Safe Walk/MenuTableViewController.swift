//
//  MenuTableViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/29/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit

class MenuTableViewController : UITableViewController {
  
  // Cell UILabel tag
  let kCellLabelViewTag = 1
  
  // Menu options -- keep in sync with menuControllers (same order)
  let menuOptions = ["Groups", "Walks", "Requests"]
  
  // Menu controllers -- keep in sync with menuOptions (same order)
  let menuIdentifiers = ["GroupsViewController", "WalksViewController", "WalksViewController"]

  
  //
  // MARK: UITableViewDelegate
  //
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let identifier = menuIdentifiers[indexPath.row]
    let controller = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: identifier) ?? UIViewController()
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let screenSize = UIApplication.shared.keyWindow!.screen.bounds.height - self.navigationController!.navigationBar.frame.height;
    return (screenSize / 3) as CGFloat;
  }
  
  //
  // MARK: UITableViewDataSource
  //
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuOptions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell") {
      let label = cell.viewWithTag(kCellLabelViewTag) as? UILabel
      label?.text = menuOptions[indexPath.row]
      cell.contentView.layer.borderWidth = 10
      
      return cell
    } else {
      // fail gracefully
      return UITableViewCell()
    }
  }
  
}
