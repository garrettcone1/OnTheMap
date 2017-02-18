//
//  PostingPinViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 2/15/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostingPinViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterWebsiteTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        
        findLocationButton.layer.cornerRadius = 5
        findLocationButton.clipsToBounds = true
        
        self.enterLocationTextField.delegate = self
        self.enterWebsiteTextField.delegate = self
    }
    
    @IBAction func cancelActioin(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        
        if enterLocationTextField.text!.isEmpty || enterWebsiteTextField.text!.isEmpty {
            self.errorAlert("Location or Website fields Empty")
        } else {
            
            Client.sharedInstance().getPublicUserData() { (success, errorString) in
                
                if success {
                    self.postStudentLocation()
                    print("Success in getting Public User Data")
                } else {
                    self.errorAlert(errorString!)
                }
            }
        }
    }
    
    func postStudentLocation() {
        
        performUIUpdatesOnMain {
            
            Client.sharedInstance().postNewStudentLocation(userID: UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName, mediaURL: self.enterWebsiteTextField.text!, mapString: self.enterLocationTextField.text!) { (success, errorString) in
                
                if success {
                    print("Success in posting new Student Location")
                } else {
                    print("Failed to POST: \(errorString)")
                    self.errorAlert("Failed to add new Student Location")
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.enterLocationTextField.resignFirstResponder()
        self.enterWebsiteTextField.resignFirstResponder()
        return true
    }
    
    
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
