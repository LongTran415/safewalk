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

  
  override func viewDidLoad() {
    let image = UIImage(named: "Image-3", in: Bundle.main, compatibleWith: nil)
    let newImage = image?.imageScaledToSize(CGSize(width: 1100, height: 800))
    let imageView = UIImageView(image: newImage)
    self.view.insertSubview(imageView, at: 0)
  }
  
  //
  // MARK: UITableViewDelegate
  //
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let identifier = menuIdentifiers[indexPath.row]
    let controller = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: identifier) ?? UIViewController()
  
    // deselect table row
    tableView.deselectRow(at: indexPath, animated: true)

    self.navigationController?.pushViewController(controller, animated: true)
  }
  
 
  
  //
  // MARK: UITableViewDataSource
  //
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuOptions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell") {
      
      cell.selectedBackgroundView = UIView(frame: cell.frame)
      cell.selectedBackgroundView?.backgroundColor = .black
      
      
      let label = cell.viewWithTag(kCellLabelViewTag) as? UILabel
      label?.text = menuOptions[indexPath.row]
      label?.font = UIFont(name: "Futura", size: 30)
      
      return cell
    } else {
      // fail gracefully
      return UITableViewCell()
    }
  }
  
}












