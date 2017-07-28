//
//  BeerHTTPClient.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Foundation

typealias CompletionBeersSuccess = (_ repositories: [Beer]) -> Void
typealias CompletionBeersFailure = (_ statusCode: Int, _ response: Any?, _ error: Error?) -> Void

class BeerHTTPClient: HTTPClient {
    
    class func getRepositories(page: Int, success: @escaping CompletionBeersSuccess, failure: @escaping CompletionBeersFailure) {
        
        let url = "\(Constants.API.kBaseUrl)/search/repositories?q=language:Java&sort=stars&page=\(page)"
        
        super.request(method: .GET, url: url, success: { (statusCode, response) in
            
            var shots = [Beer]()
            let itemsArray = response.object["items"].array
            
            guard itemsArray != nil else {
                success([])
                return
            }
            
            let items = JSONSerializer(itemsArray!)
            
            for item in items.object {
                let json = JSONSerializer(item.1.object)
            }
            
            success(shots)
            
        }) { (statusCode, response, error) in
            
            failure(statusCode, response, error)
            
        }
    }
}
