//
//  UIImageView.swift
//  BeerListing
//
//  Created by Felipe Lefèvre Marino on 7/29/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    func load(stringUrl: String) {
        if let url = URL(string: stringUrl) {
            self.af_setImage(withURL: url, placeholderImage: UIImage(named: "beer-placeholder"),
                             filter: nil, progress: nil, progressQueue: DispatchQueue.main,
                             imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false,
                             completion: nil)
        }
    }
}
