//
//  FinishPostingPinViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 2/18/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FinishPostingPinViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadMap()
        
        self.mapView.delegate = self
        
        finishButton.layer.cornerRadius = 5
        finishButton.clipsToBounds = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setAnnotations()
    }
    
    @IBAction func finishPostingPin(_ sender: Any) {
        
        performUIUpdatesOnMain {
            
            self.postStudentLocation() { (success) in
            
                if (success) {
                    
                    self.dismiss(animated: true, completion: nil)
                } else {
                    
                    // Add an alert message here
                    print("Check your internet connection")
                }
            }
        }
    }
    
    func loadMap() {
        
        let lat = CLLocationDegrees(LocationData.latitude as Double)
        let long = CLLocationDegrees(LocationData.longitude as Double)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        self.coordinate = coordinate
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(1, 1))
        mapView.setRegion(region, animated: true)
        
    }
    
    func setAnnotations() {
        
        var annotations = [MKPointAnnotation]()
        
        let annotation = MKPointAnnotation()
            
        annotation.title = UserData.firstName + " " + UserData.lastName
        print(annotation.title!)
        annotation.coordinate = self.coordinate
        print(annotation.coordinate)
        annotation.subtitle = LocationData.enteredWebsite
        print(annotation.subtitle!)
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
        
    }
    
    func postStudentLocation(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        
        performUIUpdatesOnMain {
            
            self.setAnnotations()
            
            if UserData.objectId == "" {
                Client.sharedInstance().postNewStudentLocation(userID: UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName, mediaURL: LocationData.enteredWebsite, mapString: LocationData.enteredLocation) { (success, errorString) in
                
                    performUIUpdatesOnMain {
                        
                    
                        if success {
                            
                            Client.sharedInstance().getStudentLocations() { (results, error) in
                                
                                if results != nil {
                                    
                                    print("Success in posting new Student Location and getting other student locations")
                                    completionHandler(true)
                                } else {
                                    completionHandler(false)
                                }
                            }
                                
                        } else {
                            print("Failed to POST: \(errorString)")
                            self.errorAlert(errorString)
                        }
                    }
                }
            } else {
                
                // Call PUT Method Here
                Client.sharedInstance().changeMyLocation(objectId: UserData.objectId, userID: UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName, mediaURL: LocationData.enteredWebsite, mapString: LocationData.enteredLocation) { (success, errorString) in
                    
                    performUIUpdatesOnMain {
                    
                        if success {
                            completionHandler(true)
                            print("Success in changing your student location")
                            
                            Client.sharedInstance().getStudentLocations() { (results, error) in
                                
                                performUIUpdatesOnMain {
                                    
                                    if results != nil {
                                    
                                        print("Success in posting new Student Location and getting other student locations")
                                        completionHandler(true)
                                    }
                                }
                            }
                            
                        } else {
                            self.errorAlert(errorString!)
                            completionHandler(false)
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let app = UIApplication.shared
            if let toOpen = URL(string: ((view.annotation?.subtitle)!)!) {
                
                app.open(toOpen, options: [:]) { (success) in
                    
                    if (success) {
                        print("Successfully loaded URL in subtitle description")
                    } else {
                        self.errorAlert("Could not load the URL")
                    }
                }
            }
        }
    }
    
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

