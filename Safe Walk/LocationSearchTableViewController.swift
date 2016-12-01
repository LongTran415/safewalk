//
//  LocationSearchTableViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/30/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController : UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {

  //
  // MARK: Instance Variables
  //

  // This is our list of matching search result items
  var matchingItems: [MKMapItem] = []
  
  // This mapView property should be set by the presenting ViewController
  var mapView: MKMapView? = nil
  
  // Our delegate
  var delegate: LocationSearchDelegate?

  
  //
  // MARK: UISearchControllerDelegate
  //
  func updateSearchResults(for searchController: UISearchController) {

    guard
      let mapView = mapView,
      let searchQuery = searchController.searchBar.text
      else { return }
    
    let request = MKLocalSearchRequest()
    
    request.naturalLanguageQuery = searchQuery
    request.region = mapView.region
    
    MKLocalSearch(request: request).start { (response, error) in
      guard
        let response = response
        else { return }
      
      self.matchingItems = response.mapItems
      self.tableView.reloadData()
    }
  }
  
  
  //
  // MARK: UITableViewDataSource
  //
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matchingItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")

    let selectedItem = matchingItems[indexPath.row].placemark
    let addressLines = selectedItem.addressDictionary?["FormattedAddressLines"] as? [String]
    let detailText = addressLines?.joined(separator: " ")

    cell?.textLabel?.text = selectedItem.name
    cell?.detailTextLabel?.text = detailText
    
    return cell ?? UITableViewCell()
  }
  
  
  //
  // MARK: UITableViewDelegate
  //
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let placemark = matchingItems[indexPath.row].placemark
    
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.didSelect(placemark: placemark)
  }
}
