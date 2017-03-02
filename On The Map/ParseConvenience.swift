//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Garrett Cone on 2/28/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ParseClientAPI {
    
    func postNewStudentLocation(userID: String, firstName: String, lastName: String, mediaURL: String, mapString: String, _ completionHandler: @escaping (_ success: Bool, _ errorString: String) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString) { (placemarks, error) -> Void in
            
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = (placemark.location!.coordinate)
                let latitude = coordinates.latitude
                let longitude = coordinates.longitude
                
                let jsonBody: [String: AnyObject] = [
                    
                    Constants.JSONBodyKeys.uniqueKey: userID as AnyObject,
                    Constants.JSONBodyKeys.FirstName: firstName as AnyObject,
                    Constants.JSONBodyKeys.LastName: lastName as AnyObject,
                    Constants.JSONBodyKeys.Latitude: latitude as AnyObject,
                    Constants.JSONBodyKeys.Longitude: longitude as AnyObject,
                    Constants.JSONBodyKeys.MediaURL: mediaURL as AnyObject,
                    Constants.JSONBodyKeys.MapString: mapString as AnyObject
                ]
                print("\nIn postNewStudentLocation, jsonBody: \(jsonBody)")
                let _ = self.taskForParsePOSTMethod(Constants.Methods.Location, jsonBody: jsonBody) { (JSONResult, error) in
                    
                    if let error = error {
                        print(error)
                        completionHandler(false, "Could not POST Student Location.")
                    } else {
                        
                        guard let objectId = JSONResult?[Constants.JSONResponseKeys.objectID] as? String else {
                            print("Could not find key: '\(Constants.JSONResponseKeys.objectID)' in \(JSONResult)")
                            return
                        }
                        
                        UserData.objectId = objectId
                        print("\nIn postNewStudentLocation, Successful posting of my location: ObjectId: \(objectId)")
                        
                        completionHandler(true, "Success in parsing for the POST Method.")
                    }
                }
            }
        }
    }
    
    func changeMyLocation( userID: String, firstName: String, lastName: String, mediaURL: String, mapString: String, _ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let jsonBody: [String: AnyObject] = [
            Constants.JSONBodyKeys.uniqueKey: userID as AnyObject,
            Constants.JSONBodyKeys.FirstName: firstName as AnyObject,
            Constants.JSONBodyKeys.LastName: lastName as AnyObject,
            Constants.JSONBodyKeys.MediaURL: mediaURL as AnyObject,
            Constants.JSONBodyKeys.MapString: mapString as AnyObject
        ]
        
        let _ = taskForParsePUTMethod(Constants.Methods.Location, objectId: UserData.objectId, jsonBody: jsonBody) { (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(false, "Could not change your student location.")
            } else {
                print("Successfully changed your student location.")
                
                guard let jsonResult = JSONResult as? [String: AnyObject] else {
                    print("No data was found")
                    return
                }
                print(jsonResult)
                
                completionHandler(true, nil)
            }
        }
    }
    
    // This function is to get my own student location and get the object ID as well
    func getMyParseObjectID(uniqueKey: String, _ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
        
            Constants.OTMParameterKeys.queryWhere: uniqueKey as AnyObject
        ]
        
        let _ = getStudentLocationFromParse(Constants.Methods.Location, parameters: parameters) { (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(false, "Could not get objectID")
            } else {
                
                guard let uniqueKey = JSONResult?[Constants.JSONResponseKeys.uniqueKey] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.uniqueKey)' in \(JSONResult)")
                    return
                }
                
                UserData.uniqueKey = uniqueKey
                print("\nIn getMyParseObjectID, Success in getting my uniqueKey: \(uniqueKey)")
                
                guard let objectId = JSONResult?[Constants.JSONResponseKeys.objectID] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.objectID)' in \(JSONResult)")
                    return
                }

                UserData.objectId = objectId
                print("\nIn getMyParseObjectID, Success in getting my objectId: \(objectId)")
                completionHandler(true, "Success in parsing for the GET Method.")
            }
        }
    }
    
    func getStudentLocations(_ completionHandler: @escaping (_ results: [StudentLocation]?, _ errorString: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            Constants.OTMParameterKeys.limit: 100 as AnyObject,
            Constants.OTMParameterKeys.skip: 400 as AnyObject,
            Constants.OTMParameterKeys.order: "-updatedAt" as AnyObject
        ]
        
        let _ = taskForParseGETMethod(Constants.Methods.Location, parameters: parameters) { (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(nil, "Could not get student locations")
            } else {
                // Return the locations result, otherwise let us know that there were no results in the output
                if let locations = JSONResult?[Constants.JSONResponseKeys.LocationResults] as? [[String: AnyObject]] {
                    StudentArray.sharedInstance.myArray = StudentLocation.locationsFromResults(locations)
                    completionHandler(StudentArray.sharedInstance.myArray, nil)
                } else {
                    completionHandler(nil, "JSONResult was empty")
                }
            }
        }
    }
}
