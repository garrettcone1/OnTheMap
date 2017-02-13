//
//  MapViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 1/23/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMapLocations()
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        Client.sharedInstance().goLogout() { (success, errorString) in
            performUIUpdatesOnMain {
                
                if (success) {
                    self.dismiss(animated: false, completion: nil)
                
                } else {
                    print("Log Out Failed")
                    self.errorAlert("Log Out Failed")
                }
            }
        }
    }
    
    func getMapLocations() {
        
        Client.sharedInstance().getStudentLocations() { (results, errorString) in
            
            performUIUpdatesOnMain {
                if (results != nil) {
                
                    print("Success! Downloaded Student Locations")
                    self.setMapLocations()
                    
                } else {
                    print("Could not get student locations")
                    self.errorAlert("Could not get student locations")
                }
            }
        }
    }
    
    func setMapLocations() {
        
        let locations = StudentArray.sharedInstance.myArray
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            // The lat and long are going to be used to create a CLLocationCoordinated2D instance
            let lat = CLLocationDegrees(location.latitude as Double)
            let long = CLLocationDegrees(location.longitude as Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName as String
            let last = location.lastName as String
            let mediaURL = location.mediaURL as String
            
            // Create the annotation and set its coordinate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Place the annotation in an array of annotations
            annotations.append(annotation)
        }
        
        self.mapView.delegate = self
        // Annotations array is complete, add them to the map
        self.mapView.addAnnotations(annotations)
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

