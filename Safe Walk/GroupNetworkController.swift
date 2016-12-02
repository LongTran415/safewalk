//
//  GroupNetworkController.swift
//  Safe Walk
//
//  Created by Long Work on 12/1/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import Foundation

class GroupNetworkController:NetworkController {
  
  func getUserGroups(onSuccess: @escaping (_ data: Data?) -> Void, onFailure: @escaping (_
    errorMessage: String) -> Void) {
    
    let request = templateGetAuthRequest(urlString: "http://localhost:3000/api/users/\(network.userId!)/groups")
    
    self.session.dataTask(with: request) { (data, response, error) -> Void in
      let httpResponse = response as? HTTPURLResponse
      
      if httpResponse?.statusCode == 200 {
        onSuccess(data)
      } else {
        onFailure("Failed to get Groups :(")
      }
    }.resume()
  }
  
  func createGroup(name: String, location: String, description: String, onSuccess: @escaping () -> Void, onFailure: @escaping (_ _errorMessage: String) -> Void) {
    // params
    let params: [String:String] = ["name": name, "location": location, "description": description]

    // POST request
    let request = self.templatePostRequest(urlString: "http://localhost:3000/api/groups", params: params)
    
    self.session.dataTask(with: request) { (data, response, error) -> Void in
      
      let htttpResponse = response as? HTTPURLResponse
      
      if htttpResponse?.statusCode == 201 {
        onSuccess()
      } else {
        onFailure("Failed to create group")
      }
      }.resume()
    }
  }


