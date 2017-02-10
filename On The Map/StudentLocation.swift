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
    
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    
    var latitude: Double?
    var longitude: Double?
    
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String? //= nil
    
    
    static var sharedInstance = StudentLocation()
    var studentLocationList = [StudentLocation]()
    
    init() {
        createdAt = ""
        firstName = ""
        lastName = ""
    
        latitude = 0.0
        longitude = 0.0
    
        mapString = ""
        mediaURL = ""
        objectId = ""
        uniqueKey = ""
        updatedAt = ""
    }
    
    // != nil ? dictionary[Constants.JSONResponseKeys.CreatedAt] as? String: ""
    // != nil ? dictionary[Constants.JSONResponseKeys.latitude] as? Double: 0
    
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary[Constants.JSONResponseKeys.CreatedAt] as? String
        firstName = dictionary[Constants.JSONResponseKeys.FirstName] as? String
        lastName  = dictionary[Constants.JSONResponseKeys.LastName] as? String
        
        latitude  = dictionary[Constants.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[Constants.JSONResponseKeys.longitude] as? Double
        
        mapString = dictionary[Constants.JSONResponseKeys.mapString] as? String
        mediaURL  = dictionary[Constants.JSONResponseKeys.mediaURL] as? String
        objectId  = dictionary[Constants.JSONResponseKeys.objectID] as? String
        uniqueKey = dictionary[Constants.JSONResponseKeys.uniqueKey] as? String
        updatedAt = dictionary[Constants.JSONResponseKeys.updatedAt] as? String
        
        
        
        
    }
    
    // Convert an array of dictionaries to an array of student information struct objects
    static func locationsFromResults(_ results: [[String : AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
    
}
