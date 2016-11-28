//
//  NetworkSession.swift
//  SafeWalk
//
//  Created by Long Work on 11/27/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import Foundation

class NetworkSession {
  
  //
  // MARK: Singleton Setup
  //
  
  // What does   static let sharedInstance: NetworkSession = {}() mean?
  //
  // static = make this a class variable
  // let = constant
  // sharedInstance = var name
  // NetworkSession = the return value
  // = { //code }() -- computed property read-only -- this will run the code inside only 1 time, and cache the return value for future use
  //
  
  static let shared: NetworkSession = {
    let instance = NetworkSession()
    
    return instance
  }()
  
  
  //
  // MARK: Instance Properties
  //
  
  let session: URLSession = {
    // Grab the default URL session
    let urlSession = URLSession.shared
    
    urlSession.configuration.httpShouldSetCookies = true
    urlSession.configuration.httpCookieAcceptPolicy = .always
    urlSession.configuration.httpCookieStorage?.cookieAcceptPolicy = .always
        
    return urlSession
  }()
  
}
