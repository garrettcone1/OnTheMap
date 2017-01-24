//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Garrett Cone on 1/23/17.
//  Copyright © 2017 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
