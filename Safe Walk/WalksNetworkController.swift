//
//  MapNetworkController.swift
//  SafeWalk
//
//  Created by Long Work on 11/28/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import Foundation

class WalksNetworkController:NetworkController {
  
  func getUserWalks(onSuccess: @escaping (_ data: Data?) -> Void, onFailure: @escaping (_ errorMessage: String) -> Void) {
    let request = templateGetAuthRequest(urlString: "http://localhost:3000/api/users/\(network.userId!)/walks")
    
    self.session.dataTask(with: request) { (data, response, error) -> Void in
      let httpResponse = response as? HTTPURLResponse
      
      if httpResponse?.statusCode == 200 {
        onSuccess(data)
      } else {
        onFailure("Failed to get user walks")
      }
    }.resume()
  }
  
  
  func submitWalk(startingLocation: String?, destination: String?, walkTime: Date?, onSuccess: @escaping () -> Void, onFailure: @escaping (_ errorMessage: String) -> Void) {
    let params = makeParams(startingLocation: startingLocation, destination: destination, walkTime: walkTime)
    let request = templatePostRequest(urlString: "http://localhost:3000/api/users/\(network.userId!)/walks", params: params)
  
    self.session.dataTask(with: request) { (data, response, error) -> Void in
      let httpResponse = response as? HTTPURLResponse
      
      if httpResponse?.statusCode == 200 {
        onSuccess()
      } else {
        onFailure("Failed to post a walk")
      }
    }.resume()
  }
  
  private func makeParams(startingLocation: String?, destination: String?, walkTime: Date?) -> [String:AnyObject] {
    var params: [String:AnyObject] = [:]
    var walkParams: [String:AnyObject] = [:]
    let dateString = walkTime?.description
    
    walkParams["starting_location"] = startingLocation as AnyObject?
    walkParams["walk_time"] = dateString as AnyObject?
    walkParams["destination"] = destination as AnyObject?
    params["walk"] = walkParams as AnyObject?

    return params
  }
}
