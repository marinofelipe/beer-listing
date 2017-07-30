//
//  RefreshControl.swift
//  BeerListing
//
//  Created by Felipe Lefèvre Marino on 7/30/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Foundation
import UIKit

public protocol RefreshControlDelegate: class {
    func willRefresh()
}

public class RefreshControl: UIRefreshControl {
 
    public weak var delegate: RefreshControlDelegate?
    
    // MARK: Initializers
    public override init() {
        super.init()
    }
    
    public convenience init?(withTitle title: String, color: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 17)) {
        self.init()
        config(withTitle: title, color: color, font: font)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configurations
    private func config(withTitle title: String, color: UIColor, font: UIFont) {
        attributedTitle = NSAttributedString(string: title, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
        addTarget(self, action: #selector(RefreshControl.refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        if let delegate = delegate {
            delegate.willRefresh()
        }
    }
}
