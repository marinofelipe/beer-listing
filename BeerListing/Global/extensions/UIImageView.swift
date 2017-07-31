//
//  UIImageView.swift
//  BeerListing
//
//  Created by Felipe Lefèvre Marino on 7/29/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import UIKit
import AlamofireImage

public typealias DidDownloadImage = () -> Void

extension UIImageView {
    
    func load(stringUrl: String, completionImage: @escaping DidDownloadImage) {
        if let url = URL(string: stringUrl) {
            self.af_setImage(withURL: url, placeholderImage: UIImage(named: Constants.Beers.kImagePlaceholder),
                             filter: nil, progress: nil, progressQueue: DispatchQueue.main,
                             imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false,
                             completion: { _ in
                                completionImage()
            })
        }
    }
}
