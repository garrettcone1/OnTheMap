//
//  StudentLocation.swift
//  On The Map
//
//  Created by Garrett Cone on 2/2/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation {
    
    var createdAt: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var mapString: String = ""
    var mediaURL: String = ""
    var objectId: String = ""
    var uniqueKey: String = ""
    var updatedAt: String = ""
   
    init(dictionary: [String : AnyObject]) {
        
        if let createdAt = dictionary[Constants.JSONResponseKeys.CreatedAt] as? String {
            self.createdAt = createdAt
        }
        
        if let firstName = dictionary[Constants.JSONResponseKeys.FirstName] as? String {
            self.firstName = firstName
        }
        
        if let lastName  = dictionary[Constants.JSONResponseKeys.LastName] as? String {
            self.lastName = lastName
        }
        
        if let latitude  = dictionary[Constants.JSONResponseKeys.latitude] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary[Constants.JSONResponseKeys.longitude] as? Double {
            self.longitude = longitude
        }
        
        if let mapString = dictionary[Constants.JSONResponseKeys.mapString] as? String {
            self.mapString = mapString
        }
        
        if let mediaURL  = dictionary[Constants.JSONResponseKeys.mediaURL] as? String {
            self.mediaURL = mediaURL
        }
        
        if let objectId  = dictionary[Constants.JSONResponseKeys.objectID] as? String {
            self.objectId = objectId
        }
        
        if let uniqueKey = dictionary[Constants.JSONResponseKeys.uniqueKey] as? String {
            self.uniqueKey = uniqueKey
        }
        
        if let updatedAt = dictionary[Constants.JSONResponseKeys.updatedAt] as? String {
            self.updatedAt = updatedAt
        }
    }
    
}

extension StudentLocation {
    
    // Convert an array of dictionaries to an array of student information struct objects
    static func locationsFromResults(_ results: [[String : AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
    
}
