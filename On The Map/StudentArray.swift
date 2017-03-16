//
//  StudentArray.swift
//  On The Map
//
//  Created by Garrett Cone on 2/13/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

class StudentArray {
    
    class var sharedInstance: StudentArray {
        
        struct Static {
            static var instance: StudentArray = StudentArray()
        }
        
        return Static.instance
    }
    
    var myArray: [StudentLocation] = [StudentLocation]()
    
    //var studentLocation: StudentLocation!
    
    static func locationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
}


