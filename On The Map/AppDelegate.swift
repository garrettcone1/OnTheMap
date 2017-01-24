//
//  AppDelegate.swift
//  On The Map
//
//  Created by Garrett Cone on 1/20/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Properties
    var window: UIWindow?
    
    var sharedSession = URLSession.shared
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}

extension AppDelegate {
    
    func otmURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.OTM.ApiScheme
        components.host = Constants.OTM.ApiHost
        components.path = Constants.OTM.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
        
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
