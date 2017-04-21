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
        
        self.postStudentLocation() { (success) in
        
            if (success) {
                performUIUpdatesOnMain {
                    print("Successfully finalized my location")
                }
            } else {
                
                performUIUpdatesOnMain {
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
            
        annotation.title = userData.firstName + " " + userData.lastName
        print(annotation.title!)
        annotation.coordinate = self.coordinate
        print(annotation.coordinate)
        annotation.subtitle = LocationData.enteredWebsite
        print(annotation.subtitle!)
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
    }
    
    func postStudentLocation(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        
        self.setAnnotations()
        
        print("\tuserData: \(userData)")
        
        ParseClientAPI.sharedInstance().getMyParseObjectID(uniqueKey: userData.userId) { (success, errorString) in
            
            if userData.objectId == "" {
                
                ParseClientAPI.sharedInstance().postNewStudentLocation(userID: userData.userId, firstName: userData.firstName, lastName: userData.lastName, mediaURL: LocationData.enteredWebsite, mapString: LocationData.enteredLocation) { (success, errorString) in
                    
                    performUIUpdatesOnMain {
                        
                        if success {
                            completionHandler(true)
                            
                            // If successful, go on to the next view
                            let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentLocationTabBarController") as! UITabBarController
                            self.present(controller, animated: true, completion: nil)
                           
                            print("\tSuccessful POSTing new student location")
                            
                        } else {
                            completionHandler(false)
                            print("Failed to POST: \(errorString)")
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else {
                
                ParseClientAPI.sharedInstance().changeMyLocation(userID: userData.userId, firstName: userData.firstName, lastName: userData.lastName, mediaURL: LocationData.enteredWebsite, mapString: LocationData.enteredLocation) { (success, errorString) in
                    
                    if success {
                        completionHandler(true)
                        
                        // If successful, go on to the next view
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentLocationTabBarController") as! UITabBarController
                        self.present(controller, animated: true, completion: nil)
                        
                        print("\tSuccessful PUTing new student location")

                    } else {
                        completionHandler(false)
                        print("Failed to PUT: \(errorString)")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
