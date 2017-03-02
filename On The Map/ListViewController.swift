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
                }
            }
            
        } else {
            print("Invalid link")
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
        
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostingPinNavController")
            self.present(controller, animated: true, completion: nil)
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
