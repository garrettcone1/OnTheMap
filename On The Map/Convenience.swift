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
    
    func authenticateWithViewController(_ username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ sessionID: String?, _ accountKey: String?, _ errorString: NSError?) -> Void) {
        
        let jsonBody: [String: [String: AnyObject]] = ["udacity" : [
            Constants.JSONBodyKeys.username: username as AnyObject,
            Constants.JSONBodyKeys.password: password as AnyObject
        ]]
        
        let _ = taskForUdacityPOSTMethod(Constants.Methods.Session, jsonBody: jsonBody as [String : AnyObject]) { (JSONResult, error) in
        
            if let error = error {
                completionHandlerForAuth(false, nil, nil, error)
                
            } else {
                guard let session = JSONResult?[Constants.JSONResponseKeys.Session] as? [String: AnyObject] else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.Session)' in \(JSONResult)")
                    return
                }
                
                guard let sessionID = session[Constants.JSONResponseKeys.sessionID] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.sessionID)' in \(session)")
                    return
                }
                    
                guard let account = JSONResult?[Constants.JSONResponseKeys.account] as? [String: AnyObject] else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.account)' in \(JSONResult)")
                    return
                }
                
                guard let key = account[Constants.JSONResponseKeys.key] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.key)' in \(account)")
                    return
                }
                
                completionHandlerForAuth(true, sessionID, key, nil)
            }
        }
 
    }
    
    func getUdacityStudentName(_ userID: String, completionHandlerForGET: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: NSError?) -> Void) {
        
        let _ = taskForUdacityGETMethod(Constants.Methods.Users, Client.sharedInstance().userID!) { (JSONResult, error) in
            
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
    
    
    
    

