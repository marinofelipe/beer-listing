//
//  BeerHTTPClient.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Foundation
import ObjectMapper

typealias CompletionBeersSuccess = (_ repositories: [Beer]) -> Void
typealias CompletionBeersFailure = (_ statusCode: Int, _ response: Any?, _ error: Error?) -> Void

class BeersHTTPClient: HTTPClient {
    
    class func getBeers(page: Int, success: @escaping CompletionBeersSuccess, failure: @escaping CompletionBeersFailure) {
        
        //TODO: Create enum to set different number of itens per page based on the device screen. Also define a better cell size, or devide the screen height by this itens quantity to show always same value
        let url = "\(Constants.API.kBaseUrl)\(Constants.API.kGetBeers)?page=\(page)&per_page=6"
        
        super.request(method: .GET, url: url, success: { (statusCode, response) in
            
            var beers = [Beer]()
            let itemsArray = response.object
            
            guard itemsArray != nil else {
                success([])
                return
            }
            
            //FIXME: Map correctly as JSON received
            for item in itemsArray {
                if let beer = Mapper<Beer>().map(JSONString: item.0) {
                    beers.append(beer)
                }
            }

            success(beers)
        }) { (statusCode, response, error) in
            failure(statusCode, response, error)
        }
    }
}
