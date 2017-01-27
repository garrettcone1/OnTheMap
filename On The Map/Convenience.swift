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
    
    func authenticateWithViewController(_ username: String, password: String, completionHandlerForAuth: @escaping (_ sessionID: String?, _ accountKey: String?, _ errorString: String?) -> Void) {
        
        let jsonBody: [String: [String: AnyObject]] = ["udacity" : [
            Constants.JSONBodyKeys.username: username as AnyObject,
            Constants.JSONBodyKeys.password: password as AnyObject
        ]]
        
        taskForUdacityPOSTMethod(Constants.Methods.Session, jsonBody: jsonBody as [String : AnyObject]) { (JSONResult, error) in
        
            
            
        }
        
        
    }
    
    
}
