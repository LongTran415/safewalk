//
//  LocationSearchDelegate.swift
//  Safe Walk
//
//  Created by Long Work on 11/30/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSearchDelegate {
  
  func didSelect(placemark: MKPlacemark)
  
}
