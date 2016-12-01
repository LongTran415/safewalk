//
//  WalkCell.swift
//  Safe Walk
//
//  Created by Long Work on 12/1/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit

class WalkCell : UITableViewCell {
  
  @IBOutlet weak var walkTime: UILabel!
  @IBOutlet weak var startingLocation: UILabel!
  @IBOutlet weak var destination: UILabel!
  @IBOutlet weak var accepted: UILabel!
  @IBOutlet weak var pending: UILabel!

  var isAccepted: Bool {
    get {
      return !accepted.isHidden
    }
    set {
      accepted.isHidden = !newValue
      pending.isHidden = newValue
    }
  }
  
  var hideStatus: Bool {
    get {
      return accepted.isHidden && pending.isHidden
    }
    set {
      accepted.isHidden = true
      pending.isHidden = true
    }
  }
}
