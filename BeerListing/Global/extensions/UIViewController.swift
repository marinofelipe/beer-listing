//
//  SharingManager.swift
//  BeerListing
//
//  Created by Felipe Marino on 31/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Foundation
import UIKit
import Social

public enum SharingPlataform: String {
    case facebook, twitter
}

extension UIViewController {
    
    public func share(withInitialText initialText: String?, image: UIImage?) {
        let alert = UIAlertController(title: Constants.Beers.kShareTitle, message: "", preferredStyle: .alert)
        let facebookAction = UIAlertAction.init(title: "facebook", style: .default) { _ in
            self.share(onPlatform: .facebook, initialText: initialText, image: image)
        }
        let twitterAction = UIAlertAction.init(title: "twitter", style: .default) { _ in
            self.share(onPlatform: .twitter, initialText: initialText, image: image)
        }

        alert.addAction(facebookAction)
        alert.addAction(twitterAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func share(onPlatform platform: SharingPlataform, initialText: String?, image: UIImage?) {
        let composeViewController: SLComposeViewController?
        switch platform {
        case .facebook:
            composeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            break
        case .twitter:
            composeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            break
        }

        composeViewController?.setInitialText(initialText != nil ? initialText! : "")
        composeViewController?.add(image != nil ? image : nil)

        if let composeViewController = composeViewController {
            present(composeViewController, animated: true, completion: nil)
        }
    }
}
