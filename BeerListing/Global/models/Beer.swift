//
//  Beer.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import UIKit
import ObjectMapper

//TODO: Add Object mapping
public struct Beer: Mappable {
    public var imageUrl: String?
    public var name: String?
    public var alcoholicStrength: Double?
    public var tagline: String?
    public var scaleOfBitterness: Double?
    public var mainDescription: String?
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public init?(map: Map) {}
    
    init(imageUrl: String, name: String, alcoholicStrength: Double,
         tagline: String, scaleOfBitterness: Double, mainDescription: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.alcoholicStrength = alcoholicStrength
        self.tagline = tagline
        self.scaleOfBitterness = scaleOfBitterness
        self.mainDescription = mainDescription
    }
    
    // Mappable
    public mutating func mapping(map: Map) {
        imageUrl           <- map["image_url"]
        name                <- map["name"]
        alcoholicStrength   <- map["abv"]
        tagline             <- map["tagline"]
        scaleOfBitterness   <- map["ibu"]
        mainDescription     <- map["description"]
    }
}
