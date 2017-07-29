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
        let url = "\(Constants.API.kBaseUrl)\(Constants.API.kGetBeers)?page=\(page)&per_page=10"
        
        super.request(method: .GET, url: url, success: { (statusCode, response) in
            
            var beers = [Beer]()
            let jsonItems = response.object
            
            guard !response.null() else {
                success([])
                return
            }
            
            if let _beers = Mapper<Beer>().mapArray(JSONString: jsonItems.rawString()!) {
                beers = _beers
            }

            success(beers)
        }) { (statusCode, response, error) in
            failure(statusCode, response, error)
        }
    }
}
