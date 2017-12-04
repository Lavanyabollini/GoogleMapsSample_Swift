//
//  ViewController.swift
//  GoogleMapsSample_Swift
//
//  Created by mobinius on 29/11/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate, UISearchBarDelegate ,LocateOnTheMap,GMSAutocompleteFetcherDelegate  {
    var locationCoordinate=CLLocationCoordinate2D()
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var addressLabel: UILabel!
    var addressString:String! = nil
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    @IBOutlet weak var googleMapsContainer: UIView!
    
 

    
//MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        // self.loadingMapView(maptype:.normal)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }


    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.mapView = GMSMapView(frame: self.googleMapsContainer.frame)
//        self.view.addSubview(self.mapView)

        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
    
    
   
    
//MARK:- GMSAutocompleteFetcherDelegate Methods
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        // print(resultsArray)
    }
    
    
//MARK:- LocateOnTheMap custom delegate
    
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
 {
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.mapView.camera = camera
            marker.icon = UIImage(named: "MarkerImage")
            marker.title = "Address : \(title)"
            marker.map = self.mapView
            
        }
        
    }
    
//MARK:- Searchbar delegate
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        let placeClient = GMSPlacesClient()
        //
        //
        //        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil)  {(results, error: Error?) -> Void in
        //           // NSError myerr = Error;
        //            print("Error @%",Error.self)
        //
        //            self.resultsArray.removeAll()
        //            if results == nil {
        //                return
        //            }
        //
        //            for result in results! {
        //                if let result = result as? GMSAutocompletePrediction {
        //                    self.resultsArray.append(result.attributedFullText.string)
        //                }
        //            }
        //
        //            self.searchResultController.reloadDataWithArray(self.resultsArray)
        //
        //        }
        
        
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    
//MARK:- GMSMapView delegates method
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(coordinate: position.target)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
//MARK:- CLLocationManager delegate method
  
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
     
        if status == .authorizedWhenInUse {
            
         
            locationManager.startUpdatingLocation()
            
         
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
            locationManager.stopUpdatingLocation()
        }
        
    }
    

    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        //removing previous markers
        self.mapView.clear()
//        marker.title = "Hello World"
//        marker.map = mapView
        
        
        
//        let position = CLLocationCoordinate2DMake(lat, lon)
//        let marker = GMSMarker(position: position)
//
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
//        self.mapView.camera = camera
                marker.icon = UIImage(named: "MarkerImage")
        marker.title = "Address : \(String(describing:title))"
        marker.map = self.mapView
           }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //removing previous markers
        self.mapView.clear()
//        print("Tapped at coordinate: " + String(coordinate.latitude) + " "
//            + String(coordinate.longitude))
        
            

                let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
                let marker = GMSMarker(position: position)
        
                let camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude, longitude: coordinate.longitude, zoom: 5)
                self.mapView.camera = camera
           // mapView.setMinZoom(0, maxZoom: 15)

        marker.icon = UIImage(named: "MarkerImage")
        marker.title = "Address : \(String(describing: self.title))"
             marker.map = self.mapView
       
    }
    

    
//MARK:- IBAction methods
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    @IBAction func searchWithAddress(_ sender: AnyObject) {
       // self.mapView.clear()
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        
        
        self.present(searchController, animated:true, completion: nil)
        
        
    }
    
    @IBAction func changeModesButtonClicked(_ sender:UIBarButtonItem) {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let normalActionButton = UIAlertAction(title: "Normal", style: .default) { action -> Void in
            //self.loadingMapView(maptype:.normal)
         self.mapView.mapType = .normal
            print("Normal")
        }
        actionSheetController.addAction(normalActionButton)
        
        let terrainActionButton = UIAlertAction(title: "Terrain", style: .default) { action -> Void in
            self.mapView.mapType = .terrain
            //self.loadingMapView(maptype:.terrain)
            print("Terrain")
        }
        actionSheetController.addAction(terrainActionButton)
        let hybridActionButton = UIAlertAction(title: "Hybrid", style: .default) { action -> Void in
            self.mapView.mapType = .hybrid
        //   self.loadingMapView(maptype:.hybrid)
            print("Hybrid")
        }
        actionSheetController.addAction(hybridActionButton)
        
        let satelliteActionButton = UIAlertAction(title: "Satellite", style: .default) { action -> Void in
            self.mapView.mapType = .satellite
          //  self.loadingMapView(maptype:.satellite)
            
            print("satellite")
        }
        actionSheetController.addAction(satelliteActionButton)
        let noneActionButton = UIAlertAction(title: "None", style: .default) { action -> Void in
            self.mapView.mapType = .none
         //  self.loadingMapView(maptype:.none)
            print("none")
        }
        actionSheetController.addAction(noneActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func optionsButtonClicked(_ sender: UIBarButtonItem) {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let stylingActionButton = UIAlertAction(title: "Styling", style: .default) { action -> Void in
            if (self.locationCoordinate) != nil{
            self.stylingSelected(coordinate: self.locationCoordinate)
            }else{
                
            }
            print("Styling")
        }
        actionSheetController.addAction(stylingActionButton)
        
        let streetViewActionButton = UIAlertAction(title: "StreetView", style: .default) { action -> Void in
            if (self.locationCoordinate) != nil{
            self.streeViewSelected(coordinate: self.locationCoordinate)
            }
            print("streetView")
        }
        actionSheetController.addAction(streetViewActionButton)
        let polylinesActionButton = UIAlertAction(title: "Polylines", style: .default) { action -> Void in
            self.polyLinesSelected()
            print("Polylines")
        }
        actionSheetController.addAction(polylinesActionButton)
        
        let cameraActionButton = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.cameraSelected()
            print("Camera")
        }
        actionSheetController.addAction(cameraActionButton)
        let indoorActionButton = UIAlertAction(title: "Indoor", style: .default) { action -> Void in
            self.indoorSelected()
            print("Indoor")
        }
        actionSheetController.addAction(indoorActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
  
    }
    
    
    
//MARK:- Other methods
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        self.locationCoordinate = coordinate

        let geocoder = GMSGeocoder()
        
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            if let response = response {
                let  address = response.firstResult()
                
                if  let lines = address?.lines{
                    DispatchQueue.main.async {
                        self.addressLabel.text=lines.joined(separator: "\n")
                    }
                }
                
            }
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func loadingMapView(maptype:GMSMapViewType)  {
        navigationItem.title = "Hello Map"
        
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                              longitude: 151.2086,
                                              zoom: 14)
        mapView.camera=camera
        mapView.mapType=maptype
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = .pop
        marker.icon = UIImage(named: "MarkerImage")
        marker.map = mapView
        
        view = mapView
    }
    
//MARK: styling
    func stylingSelected(coordinate: CLLocationCoordinate2D) {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("The style definition could not be loaded: \(error)")
        }
    }
    
    
//MARK: streeView
    func streeViewSelected(coordinate: CLLocationCoordinate2D){
        let panoramaNear = CLLocationCoordinate2D(latitude:coordinate.latitude, longitude: coordinate.longitude)
        
        let panoView = GMSPanoramaView.panorama(withFrame: .zero,
                                                nearCoordinate: panoramaNear)
        
        view = panoView;
    }
    
    
//MARK: polylines
    func polyLinesSelected() {
//        let camera = GMSCameraPosition.camera(withLatitude: 0,
//                                              longitude: -165,
//                                              zoom: 2)
//        mapView.camera=camera
        let path = GMSMutablePath()
        path.addLatitude(-33.866, longitude:151.195) // Sydney
        path.addLatitude(-18.142, longitude:178.431) // Fiji
        path.addLatitude(21.291, longitude:-157.821) // Hawaii
        path.addLatitude(37.423, longitude:-122.091) // Mountain View
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .red
        polyline.strokeWidth = 5.0
        polyline.map = mapView
        
        view = mapView
    }
    
    func cameraSelected(){
        let camera = GMSCameraPosition.camera(withLatitude: -37.809487,
                                              longitude: 144.965699,
                                              zoom: 17.5,
                                              bearing: 30,
                                              viewingAngle: 40)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        view = mapView
    }
    func indoorSelected()
    {
        let camera = GMSCameraPosition.camera(withLatitude: 37.78318,
                                              longitude: -122.40374,
                                              zoom: 18)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        view = mapView
    }
}

