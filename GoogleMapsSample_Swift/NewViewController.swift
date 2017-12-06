//
//  NewViewController.swift
//  GoogleMapsSample_Swift
//
//  Created by mobinius on 06/12/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class NewViewController: UIViewController,UITextFieldDelegate,UISearchBarDelegate,GMSAutocompleteFetcherDelegate,LocateOnTheMap {
    
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var originTextField: UITextField!
    
    @IBOutlet weak var destinationTextField: UITextField!
    var searchResultsController: SearchResultsController!
    var gmsFetcher: GMSAutocompleteFetcher!
    var resultsArray = [String]()
        var originCoordinate: CLLocationCoordinate2D!
    
        var destinationCoordinate: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.originTextField.delegate=self
        self.destinationTextField.delegate=self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
      
        
        searchResultsController = SearchResultsController()
        searchResultsController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField==originTextField {
           self.searchForAddress()
        }
        else if textField == destinationTextField{
         //    destinationTextField.becomeFirstResponder()
 self.searchForAddress()
        }//delegate method
        

    }
    
    @nonobjc func textFieldShouldEndEditing(_ textField: UITextField!) -> Bool {  //delegate method
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
    }
    @nonobjc func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
                if textField==originTextField {
                   originTextField.resignFirstResponder()
                    destinationTextField.becomeFirstResponder()
                }
                else{
                    textField.resignFirstResponder()
                }
        return true
    }
    func searchForAddress()
    {
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
    }
    
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
    {
            DispatchQueue.main.async { () -> Void in
        let geocoder = GMSGeocoder()
        var coordinate=CLLocationCoordinate2D()
        coordinate.latitude=lat
        coordinate.longitude=lon
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            if let response = response {
                let  address = response.firstResult()
                
                if  let lines = address?.lines{
                    DispatchQueue.main.async {
                        if (self.originTextField.text?.isEmpty)!{
                            self.originTextField.text=lines.joined(separator: "\n")
                            self.originCoordinate = coordinate
                            }else{
                           self.destinationTextField.text=lines.joined(separator: "\n")
                            self.destinationCoordinate=coordinate

                        }
                    }
                }
                
            }
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
                }
//        DispatchQueue.main.async { () -> Void in
//            let viewController=ViewController()
//            let position = CLLocationCoordinate2DMake(lat, lon)
//            let marker = GMSMarker(position: position)
//
//            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
//            viewController.mapView.camera = camera
//            marker.icon = UIImage(named: "MarkerImage")
//            marker.title = "Address : \(title)"
//            marker.map = viewController.mapView
//
        }
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
        self.searchResultsController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        // print(resultsArray)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
      
        
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        let viewController=ViewController()
        viewController.getPolylineRoute(from: originCoordinate, to: destinationCoordinate)
    }
    
}
