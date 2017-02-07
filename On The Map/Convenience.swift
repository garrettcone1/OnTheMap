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
    
    func authenticateWithViewController(_ username: String?, password: String?, hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, /*_ sessionID: String?, _ accountKey: String?,*/ _ errorString: String?) -> Void) {
        self.postSessionID(username, password) { (success, errorString) in
            if success {
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    func postSessionID(_ username: String?, _ password: String?, completionHandler: @escaping (_ succes: Bool, _ errorString: String?) -> Void) {
        
        let parameters: [String: [String: AnyObject]] = [Constants.JSONBodyKeys.udacity : [
            Constants.JSONBodyKeys.username: username as AnyObject,
            Constants.JSONBodyKeys.password: password as AnyObject
            ]]
        
        let url = Constants.OTM.UdacityBaseURL + Constants.Methods.Session
        
        //let jsonBody = "{\"\"\(Constants.JSONBodyKeys.udacity)\": {\"\(Constants.JSONBodyKeys.username)\": \"\(username)\", \"\(Constants.JSONBodyKeys.password)\": \"\(password)\"}}"
        
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
    
    func getStudentLocations(_ completionHandler: @escaping (_ results: [StudentLocation]?, _ errorString: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            Constants.OTMParameterKeys.limit: 100 as AnyObject,
            Constants.OTMParameterKeys.skip: 400 as AnyObject,
            Constants.OTMParameterKeys.order: "-updatedAt" as AnyObject
        ]
        
        let method = Constants.Methods.Location
        let _ = taskForParseGETMethod(method, parameters: parameters) { (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(nil, "Could not get student locations")
            } else {
                // Return the locations result, otherwise let us know that there were no results in the output
                if let locations = JSONResult?[Constants.JSONResponseKeys.LocationResults] as? [[String: AnyObject]] {
                    StudentLocation.sharedInstance.studentLocationList = StudentLocation.locationsFromResults(locations)
                    completionHandler(StudentLocation.sharedInstance.studentLocationList, nil)
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
    
    func getUdacityStudentName(_ userID: String, completionHandlerForGET: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: NSError?) -> Void) {
        
        let _ = taskForUdacityGETMethod(Constants.Methods.Users, StudentLocation.sharedInstance.userID!) { (JSONResult, error) in
            
            if let error = error {
                
                completionHandlerForGET(false, nil, nil, error)
            } else {
                
                guard let user = JSONResult?[Constants.JSONResponseKeys.user] as? [String: AnyObject] else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.user)' in \(JSONResult)")
                    return
                }
                
                guard let userFirstName = user[Constants.JSONResponseKeys.first_Name] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.first_Name)' in \(user)")
                    return
                }
                
                guard let userLastName = user[Constants.JSONResponseKeys.last_Name] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.last_Name)' in \(user)")
                    return
                }
                
                completionHandlerForGET(true, userFirstName, userLastName, nil)
            }
        }
    }
 
        
}
    
    
    
    

