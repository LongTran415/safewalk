//
//  LoginNetworkController.swift
//  SafeWalk
//
//  Created by Long Work on 11/27/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import Foundation

class LoginNetworkController {

  //
  // MARK: Instance Properties
  //
  
  // Our shared session for network requests
  let network = NetworkSession.shared
  let session = NetworkSession.shared.session
    
  // Our request to use for the POST
  // Customized to be a POST, to use Cookies, and to be type JSON
  var loginRequest: URLRequest = {
    //
    // This request should send our email/password to rails
    // to POST /login with the JSON body { email: <str>, password: <str> }
    //
    
    // Create the url
    let loginUrl = URL(string: "http://localhost:3000/api/sessions")

    // Create the request
    var urlRequest = URLRequest(url: loginUrl!)
    
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

  
  //
  // MARK: Public methods
  //
  
  // This is called from our ViewController to log into the server
  func login(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (_ errorMessage: String) -> Void) {
    
    getCsrfToken(onSuccess: { csrf in
      self.postUserAuthentication(email: email, password: password, csrf: csrf, onSuccess: onSuccess, onFailure: onFailure)
    }, onFailure: onFailure)
  }
  
  
  //
  // MARK: Private methods
  //
  
  private func postUserAuthentication(email: String, password: String, csrf: String, onSuccess: @escaping () -> Void, onFailure: @escaping (_ errorMessage: String) -> Void) {
    self.loginRequest.addValue(csrf, forHTTPHeaderField: "x_csrf_token")

    // Create a request dictionary to represent our params for logging in
    let params: [String:String] = ["email": email, "password": password]
    
    // Serialize our request dictionary into JSON, and convert that to a raw "data" object to send to the server
    // set the output of the JSON serialization as the request body
    self.loginRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
    
    // POST /login (for auth)
    // This will use the session that has been automatically set by the GET /login request
    // If the session, CSRF, username, password is valid, then the server will log us in.
    // We can then make other requests in the application as if we are logged in to the server.
    //
    self.session.dataTask(with: self.loginRequest) { (data, response, error) in
      let httpResponse = response as? HTTPURLResponse

      DispatchQueue.main.async {
        if httpResponse?.statusCode == 200 {
          onSuccess()
        } else {
          onFailure("Invalid username or password")
        }
      }
    }.resume()
  }
  
  
  private func getCsrfToken(onSuccess: @escaping (_ csrf: String) -> (), onFailure: @escaping (_ errorMessage: String) -> Void) {
    // GET /login (for the csrf token required for the POST)
    // If we are able to extract a csrf token, then we should try to do the POST
    // Add the csrf token to our header request, Rails will use this header for JSON xhr requests

    session.dataTask(with: URL(string: "http://localhost:3000/login")!) { (data, response, error) in
      DispatchQueue.main.async {
        if let error = error {
          onFailure(error.localizedDescription)
        }
        
        if let token = self.extractCsrfToken(data: data) {
          onSuccess(token)
        }
      }
    }.resume()
  }
  
  
  //
  // MARK: Private helper methods
  //

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

