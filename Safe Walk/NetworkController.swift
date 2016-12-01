//
//  NetworkController.swift
//  Safe Walk
//
//  Created by Long Work on 11/30/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import Foundation

class NetworkController {
  
  // Our shared session for network requests
  let network = NetworkSession.shared
  let session = NetworkSession.shared.session

  private var request: URLRequest?

  //
  // Get a CSRF Token from the given url
  //
//  func getCsrfToken(urlString: String, onSuccess: @escaping (_ csrf: String) -> (), onFailure: @escaping (_ errorMessage: String) -> Void) {
//    // GET /login (for the csrf token required for the POST)
//    // If we are able to extract a csrf token, then we should try to do the POST
//    // Add the csrf token to our header request, Rails will use this header for JSON xhr requests
//    
//    session.dataTask(with: URL(string: urlString)!) { (data, response, error) in
//      DispatchQueue.main.async {
//        if let error = error {
//          onFailure(error.localizedDescription)
//        }
//        
//        if let token = self.extractCsrfToken(data: data) {
//          onSuccess(token)
//        }
//      }
//    }.resume()
//  }

  
  //
  // For our given data, what is the CSRF token to use?
  //
//  func extractCsrfToken(data: Data?) -> String? {
//    
//    // If we have data
//    if let _ = data {
//      
//      // If we can get a response string (our html) back from the data
//      if let response = String(data: data!, encoding: .utf8) {
//        
//        // Then regex search for the csrf token properties
//        // <meta name="csrf-token" content="liSD5BPxnCBgY8dl9SObZi99FOun6YPDjtkaQsFB/aP+fjDRpwcfRZ9oKckdA1Tbu9YyswbF0bn7wsZw4xiwEQ==">
//        let csrfTokens = response.capturedGroups(withRegex: "csrf-token.+content=\"([\\w\\n=+/]+)\"")
//        
//        // Return the first token (as there should only be one on the page)
//        return csrfTokens.first
//      }
//    }
//    
//    return nil
//  }
  
  //
  // Sets up the request object for the post
  //
  func templatePostRequest(urlString: String, params: Any?) -> URLRequest {
    //
    // This request should send our email/password to rails
    // to POST /login with the JSON body { email: <str>, password: <str> }
    //
    
    // Create the url
    let url = URL(string: urlString)
    
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

    if let sessionKey = network.sessionKey {
      urlRequest.addValue(sessionKey, forHTTPHeaderField: "X-session-key")
    }
    
    if let params = params {
      urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
    }
    
    return urlRequest
  }
  
  
  //
  // Sets up the request object for the post
  //
  func templateGetAuthRequest(urlString: String) -> URLRequest {
    //
    // This request should send our email/password to rails
    // to POST /login with the JSON body { email: <str>, password: <str> }
    //
    
    // Create the url
    let url = URL(string: urlString)
    
    // Create the request
    var urlRequest = URLRequest(url: url!)
    
    // Set the request to be a POST
    urlRequest.httpMethod = "GET"
    
    // Says we will receive cookies (aka login cookie)
    urlRequest.httpShouldHandleCookies = true
    urlRequest.allowsCellularAccess = true
    
    // Set the content type to be JSON
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    
    if let sessionKey = network.sessionKey {
      urlRequest.addValue(sessionKey, forHTTPHeaderField: "X-session-key")
    }
    
    return urlRequest
  }
}
