//
//  ListViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 1/23/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentArray.sharedInstance.myArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")! as UITableViewCell
        
        let studentLocation = StudentArray.sharedInstance.myArray[indexPath.row]
        
        cell.imageView!.image = UIImage(named: "pinIcon")
        cell.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        cell.textLabel!.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = "\(studentLocation.mediaURL)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let locationInfo = StudentArray.sharedInstance.myArray[indexPath.row]
        let locationToLoad = locationInfo.mediaURL
        
        if locationToLoad.range(of: "http") != nil {
            
            UIApplication.shared.open(URL(string: "\(locationToLoad)")!, options: [:]) { (success) in
            
                if (success) {
                    print("URL successfully opened!")
                } else {
                    performUIUpdatesOnMain {
                        print("URL could not be loaded.")
                        self.errorAlert("Invalid link: Requires 'http://' in URL.")
                    }
                }
            }
            
        } else {
            performUIUpdatesOnMain {
            
                print("Invalid link")
                self.errorAlert("Invalid link: Requires 'http://' in URL.")
            }
        }
    }
    
    func getStudentLocations() {
        
        ParseClientAPI.sharedInstance().getStudentLocations() { (results, errorString) in
            
            performUIUpdatesOnMain {
                if (results != nil) {
                    self.tableView.reloadData()
                    
                } else {
                    self.errorAlert(errorString!)
                }
            }
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        UdacityClientAPI.sharedInstance().goLogout() { (success, errorString) in
            performUIUpdatesOnMain {
                
                if (success) {
                    self.dismiss(animated: false, completion: nil)
                    
                } else {
                    print("Log Out Failed")
                    self.errorAlert("Log Out Failed")
                }
            }
        }
    }
    
    @IBAction func addOrChangePin(_ sender: Any) {
        
        if userData.objectId == "" {
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostingNavController")
            self.present(controller, animated: true, completion: nil)
            
        } else {
            
            performUIUpdatesOnMain {
                
                let message = "User '\(userData.firstName + " " + userData.lastName)' has already posted a Student Location. Would you like to overwrite their location?"
                
                let alertController = UIAlertController()
                alertController.title = ""
                alertController.message = message
                
                let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { (action) in
                    
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostingNavController")
                    self.present(controller, animated: true, completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(overwriteAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }
    
    @IBAction func reloadButton(_ sender: Any) {
        
        getStudentLocations()
        print("Success! Downloaded Student Locations")
    }
    
    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
