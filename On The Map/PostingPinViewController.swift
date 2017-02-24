//
//  PostingPinViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 2/15/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostingPinViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterWebsiteTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        self.activityIndicator.isHidden = true
        // Rounds the corners of the buttons
        findLocationButton.layer.cornerRadius = 5
        findLocationButton.clipsToBounds = true
        
        self.enterLocationTextField.delegate = self
        self.enterWebsiteTextField.delegate = self
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        
        LocationData.enteredLocation = self.enterLocationTextField.text!
        LocationData.enteredWebsite = self.enterWebsiteTextField.text!
        
        if enterLocationTextField.text!.isEmpty || enterWebsiteTextField.text!.isEmpty {
            self.errorAlert("Location or Website fields Empty")
        } else {
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            self.getMyLocation() { (success) in
                
                if (success) {
                    print("Successfully set your location data")
                    
                    self.performSegue(withIdentifier: "lastSegue", sender: nil)
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
            
        }
    }
    
    func getMyLocation(completionHandler: @escaping (_ success: Bool) -> Void) {
        
        
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(LocationData.enteredLocation!) { (placemark, error) in
                
                performUIUpdatesOnMain {
                    
                    print(Thread.isMainThread)
                    
                    guard error == nil else {
                        print("Could not geocode the entered location: \(error)")
                        return
                    }
                
                    guard let placemark = placemark else {
                        print("No placemarks found")
                        return
                    
                    }
                    guard let latitude = placemark[0].location?.coordinate.latitude else {
                        print("This latitude placemark is: \(placemark)")
                        return
                    }
                
                    
                    guard let longitude = placemark[0].location?.coordinate.longitude else {
                        print("This longitude placemark is: \(placemark)")
                        return
                    }
                
                    LocationData.latitude = latitude
                    LocationData.longitude = longitude
                    
                    
                    print(latitude)
                    print(longitude)
                
                    completionHandler(true)

                }
            }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.enterLocationTextField.resignFirstResponder()
        self.enterWebsiteTextField.resignFirstResponder()
        return true
    }
    
    
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
