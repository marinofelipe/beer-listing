//
//  Constants.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Foundation

public struct Constants {
    
    struct API {
        static let kBaseUrl = "https://api.punkapi.com/v2/"
        static let kGetBeers = "/beers"
    }
    
    struct Cell {
        static let kIdBeer = "BeerCell"
        static let kIdDetail = "DetailCell"
    }
    
    struct Segue {
        static let kShowDetail = "ShowDetail"
    }
}
