//
//  MapNetworkController.swift
//  SafeWalk
//
//  Created by Long Work on 11/28/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import Foundation

class MapNetworkController {
  
  // Our shared session for network requests
  let session = NetworkSession.shared.session

  // Our request to use for the POST
  // Customized to be a POST, to use Cookies, and to be type JSON
  var walkRequest: URLRequest = {
    //
    // This request should send our email/password to rails
    // to POST /login with the JSON body { email: <str>, password: <str> }
    //
    
    // Create the url
    let url = URL(string: "http://localhost:3000/walks")
    
    // Create the request
    var urlRequest = URLRequest(url: url!)
    
    // Set the request to be a POST
    urlRequest.httpMethod = "POST"
    
    // Says we will receive cookies (aka login cookie)
    urlRequest.httpShouldHandleCookies = true
    urlRequest.allowsCellularAccess = true
    
    // Set the content type to be JSON
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    
    return urlRequest
  }()
  
  
  func submitWalk(address: String, date: Date) {
    var params: [String:AnyObject] = [:]
    var walkParams: [String:AnyObject] = [:]
    let dateString = date.description
    
    walkParams["starting_location"] = LocationManager.shared.coordinateString() as AnyObject?
    walkParams["walk_time"] = dateString as AnyObject?
    walkParams["destination"] = address as AnyObject?
    params["walk"] = walkParams as AnyObject?
    
    walkRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
    
    session.dataTask(with: URL(string: "http://localhost:3000/walks/new")!) { (data, _, _) in
      if let token = self.extractCsrfToken(data: data) {
        
        self.walkRequest.addValue(token, forHTTPHeaderField: "x_csrf_token")
      
        self.session.dataTask(with: self.walkRequest) { (_,_,_) in
          print("saved")
        }.resume()
      }
    }.resume()
  }
  
  
  //
  // For our given data, what is the CSRF token to use?
  //
  private func extractCsrfToken(data: Data?) -> String? {
    
    // If we have data
    if let _ = data {
      
      // If we can get a response string (our html) back from the data
      if let response = String(data: data!, encoding: .utf8) {
        
        // Then regex search for the csrf token properties
        // <meta name="csrf-token" content="liSD5BPxnCBgY8dl9SObZi99FOun6YPDjtkaQsFB/aP+fjDRpwcfRZ9oKckdA1Tbu9YyswbF0bn7wsZw4xiwEQ==">
        let csrfTokens = response.capturedGroups(withRegex: "csrf-token.+content=\"([\\w\\n=+/]+)\"")
        
        // Return the first token (as there should only be one on the page)
        return csrfTokens.first
      }
    }
    
    return nil
  }
}
