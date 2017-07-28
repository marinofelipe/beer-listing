//
//  Beer.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import UIKit

//TODO: Add Object mapping
public struct Beer {
    public var mainImage: UIImage?
    public var name: String?
    public var alcoholicStrength: String?
    public var tagline: String?
    public var scaleOfBitterness: String?
    public var mainDescription: String?
    
    init(mainImage: UIImage, name: String, alcoholicStrength: String,
         tagline: String, scaleOfBitterness: String, mainDescription: String) {
        self.mainImage = mainImage
        self.name = name
        self.alcoholicStrength = alcoholicStrength
        self.tagline = tagline
        self.scaleOfBitterness = scaleOfBitterness
        self.mainDescription = mainDescription
    }
}
