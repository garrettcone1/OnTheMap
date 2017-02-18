//
//  FinishPostingPinViewController.swift
//  On The Map
//
//  Created by Garrett Cone on 2/18/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FinishPostingPinViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.layer.cornerRadius = 5
        finishButton.clipsToBounds = true
        
        
    }
    
    
    @IBAction func finishPostingPin(_ sender: Any) {
        
        
    }
    
    
}
