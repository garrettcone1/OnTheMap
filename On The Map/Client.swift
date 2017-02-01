//
//  Client.swift
//  On The Map
//
//  Created by Garrett Cone on 1/26/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

class Client: NSObject {
    
    // PROPERTIES
    
    // Shared Session
    var session = URLSession.shared
    
    // Authentication
    var sessionID: String? = nil
    var userID: String? = nil
    var objectID: String? = nil
    
    // Student Info
    var firstName: String? = nil
    var lastName: String? = nil
    
    // Initializer
    override init() {
        super.init()
    }
    
    func taskForUdacityPOSTMethod(_ method: String, jsonBody: [String: AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let urlString = Constants.OTM.UdacityBaseURL + method
        let url = URL(string: urlString)
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"\"udacity\": {\"username\": \"\(Constants.JSONBodyKeys.username)\", \"password\": \"\(Constants.JSONBodyKeys.password)\"}}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your Udacity POST request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data(First skip the first 5 characters of the response (Security characters by Udacity))
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        
        task.resume()
        return task
        
    }
    
    func taskForUdacityGETMethod(_ method: String, _ userID: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        let urlString = Constants.OTM.UdacityBaseURL + method + "/" + userID
        let url = URL(string: urlString)
        
        let request = NSMutableURLRequest(url: url!)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            guard (error == nil) else {
                print("There was an error with your Udacity POST request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data(First skip the first 5 characters of the response (Security characters by Udacity))
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
            

        }
        task.resume()
        return task
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject? = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
}
