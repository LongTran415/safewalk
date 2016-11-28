//
//  LocationManager.swift
//  SafeWalk
//
//  Created by Long Work on 11/28/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
import MapKit

/*
 To use the standard location service, create an instance of the CLLocationManager class and configure its desiredAccuracy and distanceFilter properties.
 To begin receiving location notifications, assign a delegate to the object and call the startUpdatingLocation method.
 As location data becomes available, the location manager notifies its assigned delegate object.
 If a location update has already been delivered, you can also get the most recent location data directly from the CLLocationManager object without waiting for a new event to be delivered.
 To stop the delivery of location updates, call the stopUpdatingLocation method of the location manager object.
 
 Listing 1-1 shows a sample method that configures a location manager for use.
 The sample method is part of a class that caches its location manager object in a member variable for later use.
 (The class also conforms to the CLLocationManagerDelegate protocol and so acts as the delegate for the location manager.)
 Because the app doesn’t need precise location data, it configures the location service to report the user’s general area and send notifications only when the user moves at least half a kilometer.
 
 1. Call the authorizationStatus() class method to get the current authorization status for your app.
 
 If the authorization status is restricted or denied, your app is not permitted to use location services and you should abort your attempt to use them.
 
 2. Create your CLLocationManager object and assign a delegate to it.
 
 3. Store a strong reference to your location manager somewhere in your app.
 
 4. In iOS, if the authorization status was notDetermined, call the requestWhenInUseAuthorization() or requestAlwaysAuthorization() method to request the appropriate type of authorization from the user.
 
 5. Depending on the services you need, call one or more of the following methods:
 
 - If you use the standard location service, call the locationServicesEnabled() method.
 
 - If you use the significant location-change service, call the significantLocationChangeMonitoringAvailable() method.
 
 - If you use heading information, call the headingAvailable() method.
 
 - If you monitor geographic or beacon regions, call the isMonitoringAvailable(for:) method.
 
 - If you perform ranging on Bluetooth beacons, call the isRangingAvailable()
 */

class LocationManager: NSObject, CLLocationManagerDelegate {

  //
  // MARK: Shared Instance
  //
  
  static let shared: LocationManager = {
    let instance = LocationManager()
    
    return instance
  }()

  
  //
  // MARK: Instance Properties
  //

  
  // 
  // Lazy loaded CLLocationManager to use for setting up location services
  //
  lazy var manager: CLLocationManager? = {
    let manager = CLLocationManager()
    let status = CLLocationManager.authorizationStatus()
    
    if status == .restricted || status == .denied {
      return nil;
    }
    
    manager.delegate = self
    
    if status == .notDetermined {
      manager.requestWhenInUseAuthorization()
    }
    
    CLLocationManager.locationServicesEnabled()
    
    manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    
    return manager
  }()

  
  
}
