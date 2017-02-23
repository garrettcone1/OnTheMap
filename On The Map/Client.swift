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
    
    // Shared Session
    var session = URLSession.shared
    
    // Initializer
    override init() {
        super.init()
    }
    
    func taskForUdacityPOSTMethod(_ urlString: String, parameters: [String: [String: AnyObject]], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let url = URL(string: urlString)
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        
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
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        
        task.resume()
        return task
        
    }
    
    func taskForUdacityGETMethod(_ method: String, userID: String, firstName: String, lastName: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        
        let urlString = Constants.OTM.UdacityBaseURL + method + userID
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            guard (error == nil) else {
                print("There was an error with your Udacity POST request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!: \(response)")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data(First skip the first 5 characters of the response (Security characters by Udacity))
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
            

        }
        task.resume()
        return task
    }
    
    func taskForDELETEMethod(_ urlString: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let urlString = urlString
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            guard (error == nil) else {
                print("There was an error with your DELETE request: \(error)")
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
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
            
        }
        task.resume()
        return task
        
    }
    
    func taskForParsePOSTMethod(_ method: String, jsonBody: [String: AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let urlString = Constants.OTM.ParseBaseURL + method
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Constants.OTM.ParseApplicationID, forHTTPHeaderField: Constants.OTMParameterKeys.ApplicationID)
        request.addValue(Constants.OTM.ParseApiKey, forHTTPHeaderField: Constants.OTMParameterKeys.ApiKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your Parse POST request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!: \(response)")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
        
    }
 
    func taskForParseGETMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))
        request.addValue(Constants.OTM.ParseApplicationID, forHTTPHeaderField: Constants.OTMParameterKeys.ApplicationID)
        request.addValue(Constants.OTM.ParseApiKey, forHTTPHeaderField: Constants.OTMParameterKeys.ApiKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            guard (error == nil) else {
                print("There was an error with your Udacity POST request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!: \(response)")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        return task
        
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func parseURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.OTM.ParseScheme
        components.host = Constants.OTM.ParseHost
        components.path = Constants.OTM.ParsePath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
}
