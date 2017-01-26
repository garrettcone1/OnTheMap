//
//  LoginViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 1/20/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Email or Password Empty."
        } else {
            setUIEnabled(false)
            
            getSessionID(appDelegate.sessionID!)
        }
        
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentLocationTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func getSessionID(_ sessionID: String) {
        
        let methodParameters = [
            Constants.OTMParameterKeys.SessionID: sessionID
        ]
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: String.Encoding.utf8)
        
        let task = appDelegate.sharedSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func displayError(_ error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (Session ID)"
                }
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("The request returned a status code other than 2xx!")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range)
            
            guard let finalData = newData else {
                displayError("No data was returned by the request!")
                return
            }
            
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: finalData, options: .allowFragments) as! [String: AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(finalData)'")
                return
            }
            
            if let _ = parsedResult[Constants.JSONResponseKeys.StatusCode] as? Int {
                displayError("OnTheMap returned an error. See the '\(Constants.JSONResponseKeys.StatusCode)' and '\(Constants.JSONResponseKeys.StatusMessage)' in \(parsedResult)")
                return
            }
            
            guard let userKey = parsedResult[Constants.JSONResponseKeys.userKey] as? String else {
                displayError("Could not find key '\(Constants.JSONResponseKeys.userKey)' in \(parsedResult)")
                return
            }
            
            self.appDelegate.userKey = userKey
            self.completeLogin()
        }
        
        task.resume()
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            logoImageView.isHidden = false
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

// LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
}

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
