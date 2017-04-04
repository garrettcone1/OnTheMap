//
//  LoginViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 1/20/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//
//

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
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.errorAlert("Email or Password is Empty")
        } else {
            setUIEnabled(false)
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            UdacityClientAPI.sharedInstance().authenticateWithViewController(emailTextField.text!, password: passwordTextField.text!, hostViewController: self) { (success, errorString) in
                
                if success == true {
                    print("\nIn LoginViewController.loginPressed() ...")
                    print("\tSuccessful Authentication")
                    self.completeLogin()
                        
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                } else {
                    performUIUpdatesOnMain {
                        
                        self.errorAlert(errorString!)
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
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
    
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    //func errorAlert(_ errorString: String) {
     //   let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
     //   alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
     //   self.present(alertController, animated: true, completion: nil)
    //}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

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
