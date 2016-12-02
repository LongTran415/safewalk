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
  
  @IBOutlet weak var groupNameInput: UITextField!
  @IBOutlet weak var groupLocationInput: UITextField!
  @IBOutlet weak var groupDescriptionInput: UITextView!
  
  let networkController = GroupNetworkController()

  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Remove
    LoginNetworkController.dummyLogin({
    })

  }
  
   func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // write code here
    return UITableViewCell()
  }

  @IBAction func createGroup(_ sender: UIButton) {
    networkController.createGroup(name: groupNameInput.text!, location: groupLocationInput.text!, description: groupDescriptionInput.text!, onSuccess: {
      print("GroupsViewController: create group, success!")
    }, onFailure: { (errorMessage) in
      print("GroupsViewController: failure \(errorMessage)")
    })
  }
  
 }

