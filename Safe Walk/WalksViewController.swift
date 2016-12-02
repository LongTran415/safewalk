//
//  WalksViewController.swift
//  Safe Walk
//
//  Created by Long Work on 11/30/16.
//  Copyright © 2016 safewalk. All rights reserved.
//

import UIKit
import MapKit

class WalksViewController: UIViewController,
  MKMapViewDelegate,
  UITableViewDelegate,
  UITableViewDataSource,
  UITextFieldDelegate,
  UISearchBarDelegate,
  LocationSearchDelegate {

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
  @IBOutlet weak var table: UITableView!
  
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
  
  // The cell identifier when we have no walks
  let noWalkCellIdentifier = "PlaceholderCell"
  
  // The cell identifier for our walks
  let walkCellIdentifier = "WalkCell"
  
  // This moves the form view down by a certain amount as a hack
  // !!!: fix later
  let magicNumber = 40.0 as CGFloat
  
  // This is the amount the form should move up when using the date picker
  let formExtendAmount = 250 as CGFloat
  
  // The animation duration for our form movements
  let animationDuration = 0.4 as TimeInterval
  
  // The object to use for fetching/saving our walks
  let networkController = WalksNetworkController()
  
  // Our JSON of walks fetched from the server
  var walkJson: [String:AnyObject]?

  // The possible states for our Form
  enum FormState {
    case Hidden
    case Presented
    case Extended
  }
  
  // The current state of the Form
  var formState: FormState = .Hidden
  
  // The sections of our table
  enum TableSections: Int {
    case Add = 0
    case Upcoming = 1
    case Recent = 2
  }
  
  
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
      print("Walk created successfully")
      self.submitComplete()
    }, onFailure: { message in
      print("Walk failure :(")
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
      self.walkJson = dict as? [String:AnyObject]

      DispatchQueue.main.async {
        self.table.reloadData()
      }
      
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
  func didSelect(mapItem: MKMapItem) {
    searchController?.dismiss(animated: true, completion: nil)
    searchController?.searchBar.text = nil
    hideSearch()
    setLocationInputSelection(mapItem: mapItem)
  }
  
  
  //
  // MARK: UITableViewDataSource
  //

  func numberOfSections(in tableView: UITableView) -> Int {
    return 3;
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch TableSections(rawValue: section)! {

    case .Add:
      return ""
    
    case .Recent:
      return "Recent Walks"
    
    case .Upcoming:
      return "Upcoming Walks"
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch TableSections(rawValue: section)! {
    
    case .Add:
      return 1
      
    case .Recent:
      guard
        let walkJson = walkJson
        else { return 1 }
     
      return walkJson["recent_walks"]!.count

    case .Upcoming:
      guard
        let walkJson = walkJson
        else { return 1 }
      
      return walkJson["upcoming_walks"]!.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = TableSections(rawValue: indexPath.section)!

    // Return an add cell if we're in the add section
    if (section == .Add) {
      return tableView.dequeueReusableCell(withIdentifier: addWalkCellIdentifier) ?? UITableViewCell()
    }
    
    // Return a placeholder if we have no data for our section
    if (!tableHasDataFor(section: section)) {
      return tableView.dequeueReusableCell(withIdentifier: noWalkCellIdentifier) ?? UITableViewCell()
    }

    // Return a full blownie if it's a normal row
    if let json = walkJson {
      let cell = tableView.dequeueReusableCell(withIdentifier: self.walkCellIdentifier) as! WalkCell
      let key = jsonKeyFor(section: section)
      let walks = json[key] as! [[String:AnyObject?]]
      let walk = walks[indexPath.row]
      
      cell.walkTime.text = walk["walk_time"] as! String?
      cell.startingLocation.text = walk["starting_location"] as! String?
      cell.destination.text = walk["destination"] as! String?
      
      if section == .Recent {
        cell.hideStatus = true
      } else {
        cell.isAccepted = walk["accepted"] as! Bool
      }
      
      return cell
    }
    
    return UITableViewCell()
  }
  
  private func jsonKeyFor(section: TableSections) -> String {
    switch section {
    case .Recent:
      return "recent_walks"
    case .Upcoming:
      return "upcoming_walks"
    default:
      return ""
    }
  }
  
  private func tableHasDataFor(section: TableSections) -> Bool {
    let key = jsonKeyFor(section: section)
    
    guard
      let walkJson = walkJson
      else { return false }
    
    return walkJson[key]!.count > 0
  }
  
  
  //
  // MARK: UITableViewDelegate
  //
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = TableSections(rawValue: indexPath.section)
    tableView.deselectRow(at: indexPath, animated: true)
    
    if (section == .Add) {
      formState = .Presented
      relayoutView(animated: true)
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = TableSections(rawValue: indexPath.section)!
    
    if (section == .Add) {
      return tableView.rowHeight
    }
    
    if tableHasDataFor(section: section) {
      return 86;
    }
    
    return tableView.rowHeight
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
  
  
  
  
  
  
  
  
  
  // MARK: WIP
  enum LocationOptions {
    case Source
    case Destination
  }
  
  var source: MKMapItem?
  var dest: MKMapItem?
  
  private func setLocationInputSelection(mapItem: MKMapItem) {
    let selectedAddress = (mapItem.placemark.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: " ")
    lastSelectedInput?.text = selectedAddress
    
    if (lastSelectedInput == startingLocationInput) {
      source = mapItem
    }
    
    if (lastSelectedInput == destinationInput) {
      dest = mapItem
    }
    
    clearMap()
    addMapPins()
    
    guard
      let source = source,
      let dest = dest
      else { return }
    getDirections(source: source, destination: dest)
  }
  
  private func clearMap() {
    mapView.removeOverlays(mapView.overlays)
    mapView.removeAnnotations(mapView.annotations)
  }
  
  private func addMapPins() {
    if let source = source { addMapPin(placemark: source.placemark, forType: .Source) }
    if let dest = dest { addMapPin(placemark: dest.placemark, forType: .Destination) }
  }
  
  private func addMapPin(placemark: MKPlacemark, forType: LocationOptions) {
    let pin = MKPinAnnotationView(annotation: placemark, reuseIdentifier: nil)
    
    self.moveMapTo(coordinate: placemark.coordinate)
    self.mapView.addAnnotation(pin.annotation!)
  }
  
  private func moveMapTo(coordinate: CLLocationCoordinate2D) {
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegionMake(coordinate, span)
    mapView.setRegion(region, animated: true)
  }
  
  func getDirections(source: MKMapItem, destination: MKMapItem) {
    let request = MKDirectionsRequest()
    request.source = source
    request.destination = destination
    request.transportType = .walking
    
    let directions = MKDirections(request: request)
    directions.calculate { (response, error) in
      // TODO: Error handling
      let route = response?.routes.first
      
      if let route = route {
        self.mapView.add(route.polyline)
      }
    }
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is MKPolyline {
      let lineView = MKPolylineRenderer(overlay: overlay)
      lineView.strokeColor = UIColor.init(red: 0, green: 122, blue: 255, alpha: 0.6)
      
      return lineView
    }
    
    return MKOverlayRenderer(overlay: overlay)
  }
  
  private func submitComplete() {
    var dict = [String:AnyObject]()
    dict["walk_time"] = self.timeInput.text as AnyObject?
    dict["starting_location"] = self.startingLocationInput.text as AnyObject?
    dict["destination"] = self.destinationInput.text as AnyObject?
    
    DispatchQueue.main.async {
      self.timeInput.text = nil
      self.startingLocationInput.text = nil
      self.destinationInput.text = nil
      self.source = nil
      self.dest = nil
      self.clearMap()
      let index = IndexPath(row: 0, section: 0)
      self.getUserWalks()
      self.table.scrollToRow(at: index, at: .top, animated: true)
    }
  }
}
