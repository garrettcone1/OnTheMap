//
//  Constants.swift
//  On The Map
//
//  Created by Garrett Cone on 1/23/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct OTM {
        
        // Parse Application ID
        static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAblr"
        // REST API Key
        static let RESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gy"
        
        // URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let signUp = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        static let authMe = "https://www.udacity.com/api/session"
        
    }
    
    struct OTMParameterKeys {
        
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectID = "objectId"
        static let updatedAt = "updatedAt"
        
        static let SessionID = "id"
    }
    
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        static let userKey = "key"
        static let registered = "registered"
    
    struct Methods {
        
        // GET Methods
        static let multipleStudentLocations = "/StudentLocation"
        static let singleStudentLocation = "/StudentLocation"
        static let publicUserData = "/api/users/<user_id>"
        
        // PUT Methods
        static let updateMyLocation = "/StudentLocation/<objectId>"
        
        // POST Methods
        static let authMyRequest = "/api/session"
        
        // DELETE Methods
        static let deleteSessionToLogout = "/api/session"
        
    }
    

    
}
}
