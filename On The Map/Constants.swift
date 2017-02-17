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
        
        // API Key
        static let ParseApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // Application ID
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // Facebook App ID
        static let FacebookAppID = "365362206864879"
        
        // URLs
        static let ParseBaseURL = "https://parse.udacity.com/parse/classes/"
        static let ParseScheme = "https"
        static let ParseHost = "parse.udacity.com"
        static let ParsePath = "/parse/classes/"
        
        static let UdacityBaseURL = "https://www.udacity.com/api/"
        static let logOutBaseURL = "https://www.udacity.com/api/"
        static let signUpURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
    }
    
    struct Methods {
        
        // GETing or POSTing a location
        static let Location = "StudentLocation/"
        
        // Udacity Authentication
        static let Session = "session"
        
        static let ToDelete = "session"
        
        // Users
        static let Users = "users/"
        
        // Public User Data
        static let AuthenticationTokenNew = "authentication/token/new"
        
    }
    
    struct OTMParameterKeys {
        
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let uniqueKey = "uniqueKey"
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
        
    }
    
    struct JSONBodyKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        static let account = "account"
        
        static let uniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ACL = "ACL"
        
    }
    
    struct JSONResponseKeys {
        
        // General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // Authorization
        static let RequestToken = "request_token"
        static let Session = "session"
        static let sessionID = "id"
        
        // Account
        static let UserID = "id"
        static let account = "account"
        static let key = "key"
        
        static let user = "user"
        static let userIdKey = "key"
        static let last_Name = "last_name"
        static let first_Name = "first_name"
        static let results = "results"
        
        // Student Locations
        static let LocationResults = "results"
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
        
    }

}
