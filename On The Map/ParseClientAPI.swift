//
//  ParseClientAPI.swift
//  On The Map
//
//  Created by Garrett Cone on 2/28/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

class ParseClientAPI: NSObject {
    
    // Shared Session
    var session = URLSession.shared
    
    // Initializer
    override init() {
        super.init()
    }
    
    func taskForParsePUTMethod(_ method: String, objectId: String, jsonBody: [String: AnyObject], completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let urlString = Constants.OTM.ParseBaseURL + method + objectId
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(Constants.OTM.ParseApplicationID, forHTTPHeaderField: Constants.OTMParameterKeys.ApplicationID)
        request.addValue(Constants.OTM.ParseApiKey, forHTTPHeaderField: Constants.OTMParameterKeys.ApiKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your Parse PUT request: \(error)")
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
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        task.resume()
        return task
    }
    
    // MARK: - TODO: Complete the function getStudentLocationFromParse
    // to be called in getMyParseObjectID() in the NEW/Revised ParseClientConvenience.swift - which will need the ObjectId
    
    func getStudentLocationFromParse(_ method: String, parameters: [String: AnyObject], _ completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /*
        let urlString = Constants.OTM.ParseBaseURL + method // add "?where={"uniqueKey":"1234"}" -- use URLComponents
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        */
        // CHECK IF THIS URL IS CORRECT (MAY BE IMPLEMENTING UNIQUEKEY WRONG OR STUDENTLOCATION METHOD HAS "/" AT THE END)
        
        print("\nIn ParseClientAPI.getStudentLocationFromParse() ...")
        print("\t url: \(parseURLFromParameters(parameters, withPathExtension: method))")
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "GET"
        request.addValue(Constants.OTM.ParseApplicationID, forHTTPHeaderField: Constants.OTMParameterKeys.ApplicationID)
        request.addValue(Constants.OTM.ParseApiKey, forHTTPHeaderField: Constants.OTMParameterKeys.ApiKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("\tThere was an error with your Parse POST request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("\tYour request returned a status code other than 2xx!: \(response!)")
                return
            }
            
            guard let data = data else {
                print("\tNo data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
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
        
        print("\t url: \(parseURLFromParametersForGET(parameters, withPathExtension: method))")
        let request = NSMutableURLRequest(url: parseURLFromParametersForGET(parameters, withPathExtension: method))
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
    // Parse method for getStudentLocationFromParse()
    private func parseURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.OTM.ParseScheme
        components.host = Constants.OTM.ParseHost
        components.path = Constants.OTM.ParsePath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = URLQueryItem(name: key, value: "{\"uniqueKey\":\"\(value)\"}") // {"uniqueKey":"1234"}
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // Parse method for taskForParseGETMethod()
    private func parseURLFromParametersForGET(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
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
    
    class func sharedInstance() -> ParseClientAPI {
        struct Singleton {
            static var sharedInstance = ParseClientAPI()
        }
        return Singleton.sharedInstance
    }

}
