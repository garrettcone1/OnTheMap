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
    
    var errorMessage = String()
    
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
            debugTextLabel.text = "Email or Password is Empty."
        } else {
            setUIEnabled(false)
            
            Client.sharedInstance().authenticateWithViewController(emailTextField.text!, password: passwordTextField.text!) { (success, sessionID, userID, errorString) in
                
                // Make sure this first func "performUIUpdatesOnMain" is in the right place.
                performUIUpdatesOnMain {
                    if success {
                        
                        if let sessionID = sessionID {
                            print("Successful login for Session \(sessionID)")
                            Client.sharedInstance().sessionID = sessionID
                            Client.sharedInstance().userID = userID
                            
                            Client.sharedInstance().getUdacityStudentName(userID!) { (success, firstName, lastName, error) -> Void in
                                
                                if let error = error {
                                    print("Error retrieving student name from Udacity: \(error)")
                                    
                                } else {
                                    Client.sharedInstance().firstName = firstName
                                    Client.sharedInstance().lastName = lastName
                                }
                            }
                        
                            self.completeLogin()
                        }
                    
                    } else {
                    
                        if let error = errorString {
                            if error.localizedDescription.contains("The Internet connection appears to be offline") {
                                self.errorMessage = "The internet connection appears to be offline"
                            }
                        } else {
                            print("Login failed: no sessionID or error was returned")
                            self.errorMessage = "Invalid login or password"
                            self.debugTextLabel.text = "Invalid login or password"
                        }
                        
                        let alert = UIAlertController(title: nil, message: self.errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            
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
