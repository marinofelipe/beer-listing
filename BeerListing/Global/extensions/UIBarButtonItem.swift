//
//  UIBarButtonItem.swift
//  BeerListing
//
//  Created by Felipe Lefèvre Marino on 7/29/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    func plain() {
        title = ""
        style = .plain
        target = nil
        action = nil
    }
}
