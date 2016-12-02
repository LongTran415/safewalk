//
//  GroupViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/30/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController,
  UITableViewDelegate,
  UITableViewDataSource,
  UITextFieldDelegate {
  
  
  //
  // MARK: Interface Outlets
  //
  
  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var groupNameInput: UITextField!
  @IBOutlet weak var groupLocationInput: UITextField!
  @IBOutlet weak var groupDescriptionInput: UITextView!
  
  
  //
  // MARK: Instance properties
  //
  
  // The cell identifier for our groups
  let groupCellIdentifier = "GroupCell"

  // The object to use for fetching/saving our groups
  let networkController = GroupNetworkController()

  // Our JSON of walks fetched from the server
  var groupJson: [[String:AnyObject]]?
  
  
  //
  // MARK: ViewController Overrides
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getUserGroups()
  }
  
  
  //
  // MARK: UITableViewDataSource
  //
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.groupJson?.count ?? 0
  }
   
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let json = groupJson {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: self.groupCellIdentifier) as! GroupCell
      let group = json[indexPath.row]
      
      cell.groupName.text = group["name"] as! String?
      cell.location.text = group["location"] as! String?
      
      return cell
    }
    
    return UITableViewCell()
  }

  
  //
  // MARK: UITableViewDelegate
  //
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80;
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  
  //
  // MARK: IBAction View Actions
  //

  @IBAction func createGroup(_ sender: UIButton) {
    networkController.createGroup(name: groupNameInput.text!, location: groupLocationInput.text!, description: groupDescriptionInput.text!, onSuccess: {
      print("GroupsViewController: create group, success!")
      self.formSubmit()
    }, onFailure: { (errorMessage) in
      print("GroupsViewController: failure \(errorMessage)")
    })
  }
  
  
  //
  // MARK: private functions
  //
  
  // Getting groups for user
  private func getUserGroups() {
    // show load
    networkController.getUserGroups(onSuccess: { data in
      // turn off loading
      let dict = try! JSONSerialization.jsonObject(with: data!, options: [])
      self.groupJson = dict as? [[String:AnyObject]]

      DispatchQueue.main.async {
        self.table.reloadData()
      }
    }, onFailure: {error in
      // Code for error goes here
      print(error)
   })
  }
  
  
  private func formSubmit() {
    var dict = [String:String?]()
    dict["name"] = groupNameInput.text
    dict["location"] = groupLocationInput.text
    
    if (groupJson == nil) {
      groupJson = []
    }
    
    groupJson?.insert(dict as [String : AnyObject], at: 0)
    
    DispatchQueue.main.async {
      // Reset inputs
      self.groupNameInput.text = nil
      self.groupLocationInput.text = nil
      self.groupDescriptionInput.text = nil
      
      let indexPath = IndexPath(row: 0, section: 0)
    
      self.table.reloadData()
      self.table.scrollToRow(at: indexPath, at: .top, animated: true)
    }
  }
  
 }

