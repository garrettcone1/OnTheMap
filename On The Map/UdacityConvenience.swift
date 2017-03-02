//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Garrett Cone on 2/28/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClientAPI {
    
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
                
                UserData.userId = key
                
                self.getPublicUserData() { (success, error) in
                    
                    if (success) {
                        print("Successfully got user data")
                    } else {
                        print("Could not get user data: \(error!)")
                    }
                }
                completionHandler(true, nil)
            }
        }
    }
    
    func getPublicUserData(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForUdacityGETMethod(Constants.Methods.Users, userID: UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName) { (JSONResult, error) in
            
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
                
                UserData.firstName = firstName
                
                guard let lastName = user[Constants.JSONResponseKeys.last_Name] as? String else {
                    print("Could not find key: '\(Constants.JSONResponseKeys.last_Name)' in \(JSONResult)")
                    return
                }
                print("Passed GET lastName: \(lastName)")
                
                UserData.lastName = lastName
                
                completionHandler(true, nil)
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
