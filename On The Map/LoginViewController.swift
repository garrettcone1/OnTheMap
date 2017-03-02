//
//  LoginViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 1/20/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//
//
// MARK: - BIG TODO LIST
/*
 1) Create two separate API Client classes: 
    UdacityClientAPI,
        UdacityClientConstants
        UdacityClientConvenience
    ParseClientAPI
        ParseClientConstants
        ParseClientConvenience
 2) Implement getMyParseObjectID() in PostingPinViewController -- you to get your Parse Object ID if it exists and update your userData.objectId
        getMyParseObjectID() will call getMyStudentLocation()
 3) Implement getMyStudentLocation() in ParseClientConvenience
 */



import Foundation
import UIKit

class LoginViewController: UIViewController {

    var appDelegate: AppDelegate!
    
    // Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        
        // Get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        /*
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        */
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscribeFromAllNotifications()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.errorAlert("Email or Password is Empty")
        } else {
            setUIEnabled(false)
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            UdacityClientAPI.sharedInstance().authenticateWithViewController(emailTextField.text!, password: passwordTextField.text!, hostViewController: self) { (success, errorString) in
                
                performUIUpdatesOnMain {
                    if success {
                        
                        print("Successful Authentication")
                        self.completeLogin()
                        
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    } else {
                        self.errorAlert(errorString!)
                        
                    }
                }
            }
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentLocationTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let url = URL(string: Constants.OTM.signUpURL)
        UIApplication.shared.open(url!, options: [:]) { (success) in
            
            if success {
                print("SignUp page loaded")
            } else {
                print("SignUp page failed")
            }
        }
    }
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: Show/Hide Keyboard
    /*
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            //view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            //view.frame.origin.y += keyboardHeight(notification)
            //logoImageView.isHidden = false
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
    */
}

// LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
}
