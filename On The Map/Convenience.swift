//
//  Convenience.swift
//  On The Map
//
//  Created by Garrett Cone on 1/26/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension Client {
    
    func authenticateWithViewController(_ username: String?, password: String?, hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.postSessionID(username, password) { (success, errorString) in
            
            if success {
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    func postSessionID(_ username: String?, _ password: String?, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let parameters: [String: [String: AnyObject]] = [Constants.JSONBodyKeys.udacity : [
            Constants.JSONBodyKeys.username: username as AnyObject,
            Constants.JSONBodyKeys.password: password as AnyObject
            ]]
        
        let url = Constants.OTM.UdacityBaseURL + Constants.Methods.Session
        
        let _ = taskForUdacityPOSTMethod(url, parameters: parameters as [String: [String : AnyObject]]) { (JSONResult, error) in
            
            if let error = error {
                
                completionHandler(false, error.domain)
            } else {
                
                guard let session = JSONResult?[Constants.JSONResponseKeys.Session] as? [String: AnyObject] else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.Session)' in \(JSONResult)")
                    return
                }
                print("Passed session: \(session)")
                
                guard let sessionID = session[Constants.JSONResponseKeys.sessionID] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.sessionID)' in \(session)")
                    return
                }
                print("Passed sessionID: \(sessionID)")
                
                guard let account = JSONResult?[Constants.JSONResponseKeys.account] as? [String: AnyObject] else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.account)' in \(JSONResult)")
                    return
                }
                print("Passed account: \(account)")
                
                guard let key = account[Constants.JSONResponseKeys.key] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.key)' in \(account)")
                    return
                }
                print("Passed account key: \(key)")
                
                completionHandler(true, nil)
            }
        }
    }
    
    func postNewStudentLocation( userID: String, firstName: String, lastName: String, mediaURL: String, mapString: String, _ completionHandler: @escaping (_ success: Bool, _ errorString: String) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString) { (placemarks, error) in
            
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = (placemark.location?.coordinate)!
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
                
                let _ = self.taskForParsePOSTMethod(Constants.Methods.Location, jsonBody: jsonBody) { (JSONResult, error) in
                    
                    if let error = error {
                        print(error)
                        completionHandler(false, "Could not POST Student Location.")
                    } else {
                        
                        completionHandler(true, "Success in parsing for the POST Method.")
                    }
                }
                
                
            }
        }
 
    }
    
    func getPublicUserData(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let url = Constants.OTM.UdacityBaseURL + Constants.Methods.Users // + Constants.JSONBodyKeys.userIdKey
        
        let _ = taskForUdacityGETMethod(url, userID: UserData.userId) { (JSONResult, error) in
        
            if let error = error {
                print(error)
                completionHandler(false, "Could not get user data.")
            } else {
                
                guard let user = JSONResult?[Constants.JSONResponseKeys.user] as? [String: AnyObject] else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.user)' in \(JSONResult)")
                    return
                }
                
                guard let userID = user[Constants.JSONResponseKeys.userIdKey] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.userIdKey)' in \(JSONResult)")
                    return
                }
                print("Passed GET userID: \(userID)")
                
                guard let firstName = user[Constants.JSONResponseKeys.first_Name] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.first_Name)' in \(JSONResult)")
                    return
                }
                print("Passed GET firstName: \(firstName)")
                
                guard let lastName = user[Constants.JSONResponseKeys.last_Name] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.last_Name)' in \(JSONResult)")
                    return
                }
                print("Passed GET lastName: \(lastName)")
                
                completionHandler(true, nil)
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
    
    func goLogout(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let url = Constants.OTM.logOutBaseURL + Constants.Methods.ToDelete
        let _ = taskForDELETEMethod(url) { (JSONResult, error) in
        
            if let error = error {
                print(error)
                completionHandler(false, "Logout Failed")
            } else {
                print("Log Out Successful")
                completionHandler(true, nil)
            }
        }
    }
    
}
    
    
    
    

