//
//  WalksViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/30/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
import MapKit

class WalksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, LocationSearchDelegate {

  //
  // MARK: Interface Outlets
  //
  @IBOutlet weak var form: UIView!
  @IBOutlet weak var formConstraint: NSLayoutConstraint!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var startingLocationInput: UITextField!
  @IBOutlet weak var destinationInput: UITextField!
  @IBOutlet weak var timeInput: UITextField!
  @IBOutlet weak var groupInput: UITextField!
  
  //
  // MARK: Instance properties
  //
  
  // A datepicker to use when making a date/time selection on new walk
  weak var datePicker: UIDatePicker?
  
  // Handle on our search controller / results
  var searchController: UISearchController?
  
  // Our last selected input field (to know where to put the results of our selection object)
  var lastSelectedInput: UITextField?

  // The cell identifier to use for displaying our "+ Add Walk" in the table
  let addWalkCellIdentifier = "AddWalkCell"
  
  // This moves the form view down by a certain amount as a hack
  // !!!: fix later
  let magicNumber = 40.0 as CGFloat
  
  // This is the amount the form should move up when using the date picker
  let formExtendAmount = 250 as CGFloat
  
  // The animation duration for our form movements
  let animationDuration = 0.4 as TimeInterval
  
  // The object to use for fetching/saving our walks
  let networkController = WalksNetworkController()

  // The possible states for our Form
  enum FormState {
    case Hidden
    case Presented
    case Extended
  }
  
  // The current state of the Form
  var formState: FormState = .Hidden
  
  
  //
  // MARK: ViewController Overrides
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMapView()
    setupFormView()
    setupTapToDismissKeyboard()
    formState = .Hidden
    relayoutView(animated: false)
    
    // TODO: Remove
    LoginNetworkController.dummyLogin({
      self.getUserWalks()
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    // Stop the GPS on view exit
    LocationManager.shared.manager?.stopMonitoringSignificantLocationChanges()
  }

  
  //
  // MARK: IBAction View Actions
  //

  // Happens when the user taps on the X
  // This should just hide the form animated
  @IBAction func hideForm() {
    formState = .Hidden
    relayoutView(animated: true)
  }

  // Happens when user taps on Save
  // TODO: Add input validation, error handling, loading state, etc.
  @IBAction func submitWalkForm() {
    let datePicker = timeInput.inputView as? UIDatePicker
    let date = datePicker?.date
    
    networkController.submitWalk(startingLocation: startingLocationInput.text, destination: destinationInput.text, walkTime: date, onSuccess: {
      print("suxxeaa")
    }, onFailure: { message in
      print("failuea")
      print(message)
    })
    
    formState = .Hidden
    relayoutView(animated: true)
  }

  //
  // MARK: Programatic View Actions
  //

  // Present our search bar at the top of the page and focus it
  func presentAndFocusSearch() {
    if (searchController == nil) {
      searchController = createSearchController()
    }
    
    // Configure searchbar
    let searchBar = searchController?.searchBar
    searchBar?.sizeToFit()
    searchBar?.placeholder = "Find location"
    searchBar?.delegate = self

    // Configure navigation view
    navigationItem.titleView = searchBar
    self.navigationItem.setHidesBackButton(true, animated: true)
    
    // Change the input focus
    searchBar?.becomeFirstResponder()
  }
  
  // Hides the search bar at the top of the page
  func hideSearch() {
    navigationItem.titleView = nil
    self.navigationItem.setHidesBackButton(false, animated: true)
  }

  // View action to dismiss keyboard when tapping anywhere on screen
  func dismissKeyboard() {
    view.endEditing(true)
  }

  
  //
  // MARK: Object Creation Helpers
  //

  // Creates a search controller for us to use for searching Locations
  private func createSearchController() -> UISearchController {
    let resultsController = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
    let searchController = UISearchController(searchResultsController: resultsController)

    // Configure results controller
    resultsController.mapView = self.mapView
    resultsController.delegate = self
    
    // Configure search controller
    searchController.searchResultsUpdater = resultsController
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = true
    definesPresentationContext = true
    
    return searchController
  }
  

  //
  // MARK: Private methods for setting up view
  //
  
  private func setupMapView() {
    LocationManager.shared.manager?.startUpdatingLocation()
    mapView?.setUserTrackingMode(.follow, animated: true)
  }
  
  private func setupFormView() {
    let timeDatePicker = UIDatePicker()
    timeInput.inputView = timeDatePicker
//    timeInput.addTarget(self, action: #selector(WalksViewController.editingDidEnd(_:)), for: .editingDidEnd)
//    timeInput.addTarget(self, action: #selector(WalksViewController.editingDidBegin(_:)), for: .editingDidBegin)
  }
 
  private func setupTapToDismissKeyboard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  //
  // MARK: View Helpers
  //
  
  // Gets all of the walks for the user
  private func getUserWalks() {
    // Show loading
    networkController.getUserWalks(onSuccess: { data in
      // Turn off loading
      // Code for data goes here
      
      let dict = try! JSONSerialization.jsonObject(with: data!, options: [])
      print(dict)
    }, onFailure: { error in
      // Code for error goes here
    })
  }
  
  // Animates the presentation / hiding of form
  private func relayoutView(animated: Bool) {
    switch formState {
    case .Hidden:
      dismissKeyboard()
      formConstraint.constant = -form.bounds.height - magicNumber
    case .Presented:
      formConstraint.constant = 0
    case .Extended:
      formConstraint.constant = formExtendAmount
    }
    
    if (animated) {
      UIView.animate(withDuration: animationDuration, animations: {
        self.view.layoutIfNeeded()
      })
    }
  }
  
  
  //
  // MARK: LocationSearchDelegate
  //
  
  // Happens when making a selection on the location search
  func didSelect(placemark: MKPlacemark) {
    let selectedAddress = (placemark.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: " ")
    searchController?.dismiss(animated: true, completion: nil)
    searchController?.searchBar.text = nil
    lastSelectedInput?.text = selectedAddress
    hideSearch()
  }

  
  //
  // MARK: UITableViewDataSource
  //
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: addWalkCellIdentifier)
    
    return cell ?? UITableViewCell()
  }

  
  //
  // MARK: UITableViewDelegate
  //
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // If this is our AddWalk button
    if (indexPath.section == 0 && indexPath.row == 0) {
      formState = .Presented
      relayoutView(animated: true)
    }
  }
  
  //
  // MARK: UITextFieldDelegate
  //
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    presentAndFocusSearch()
    lastSelectedInput = textField
    return false
  }

  
  //
  // MARK: UISearchBarDelegate
  //
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    hideSearch()
  }
}
