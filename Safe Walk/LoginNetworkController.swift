//
//  LoginNetworkController.swift
//  SafeWalk
//
//  Created by Long Work on 11/27/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import Foundation

class LoginNetworkController:NetworkController {

  //
  // MARK: Public methods
  //

  static func dummyLogin(_ onSuccess: @escaping () -> Void) {
    let controller = LoginNetworkController()
    controller.login(email: "long@gmail.com", password: "long", onSuccess: onSuccess, onFailure: { (_) in })
  }
  
  
  // This is called from our ViewController to log into the server
  /*
  func login(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (_ errorMessage: String) -> Void) {
    
    getCsrfToken(urlString: "http://localhost:3000/login", onSuccess: { csrf in
      
      // Set our csrf token
      self.csrf = csrf
      
      // Setup our chicken parms
      let params: [String:String] = ["email": email, "password": password]
      
      // Generate our POST request
      let request = self.templatePostRequest(urlString: "http://localhost:3000/api/sessions", params: params)
      
      // Do it man.
      self.session.dataTask(with: request) { (data, response, error) in
        
        // Caputure our response as a URL response so we can see the status code (200 ok??)
        let httpResponse = response as? HTTPURLResponse
        
        // Run on the main UI thread because the program crashes if you don't.
        DispatchQueue.main.async {
          if httpResponse?.statusCode == 200 {
            onSuccess()
          } else {
            onFailure("Invalid username or password")
          }
        }
      }.resume()
    }, onFailure: onFailure)
  }*/
  
  func login(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (_ errorMessage: String) -> Void) {
    // Setup our chicken parms
    let params: [String:String] = ["email": email, "password": password]
    
    // Generate our POST request
    let request = self.templatePostRequest(urlString: "http://localhost:3000/api/sessions", params: params)
    
    // Do it man.
    self.session.dataTask(with: request) { (data, response, error) in
      
      // Caputure our response as a URL response so we can see the status code (200 ok??)
      let httpResponse = response as? HTTPURLResponse
      
      if (data != nil) && httpResponse?.statusCode == 200 {
        let dict = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
        self.network.userId = dict["user_id"] as! Int?
        self.network.sessionKey = dict["session_key"] as! String?
      }
      
      // Run on the main UI thread because the program crashes if you don't.
      DispatchQueue.main.async {
        if httpResponse?.statusCode == 200 {
          onSuccess()
        } else {
          onFailure("Invalid username or password")
        }
      }
    }.resume()
  }
  
}

