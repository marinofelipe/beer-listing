//
//  HTTPClient.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Alamofire

typealias CompletionApiSuccess = (_ statusCode: Int, _ response: Any?) -> Void
typealias CompletionApiFailure = (_ statusCode: Int, _ response: Any?, _ error: Error?) -> Void

class HTTPClient {
    
    enum HttpVerb: String {
        case GET, POST, PUT, DELETE
    }
    
    //TODO: Map bad requests returns
    
    fileprivate class func requestAlamofire(method: HttpVerb, url: String,
                                            parameters: [String : AnyObject]?,
                                            success: @escaping CompletionApiSuccess,
                                            failure: @escaping CompletionApiFailure) {
        
        guard Reachability.isConnected() else {
            //TODO: Enum for status returns
            failure(9999, nil, nil)
            return
        }
        
        //FIXME: add timeout
        
        let alamofireMethod = Alamofire.HTTPMethod(rawValue: method.rawValue)!
        
        //FIXME: Remove unecessary headers
        Alamofire.request(url, method: alamofireMethod, parameters: parameters, encoding: JSONEncoding.default,
                          headers: ["Accept": "application/json"])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                let value = response.result.value
                let code = response.response?.statusCode
                
                switch response.result {
                case .success:
                    success(code!, value!)
                case .failure(let error):
                    failure(code!, value!, error)
                }
        }
    }
    
    class func request(method: HttpVerb, url: String,
                       parameters: [String : AnyObject]?,
                       joinAuthToken: Bool = true,
                       success: @escaping CompletionJSONSuccess,
                       failure: @escaping CompletionJSONFailure) {
        
        self.requestAlamofire(method: method, url: url, parameters: parameters, success: { (statusCode, response) in
            
            if let value = response {
                success(_: statusCode, JSONSerializer(value))
            } else {
                failure(statusCode, response, nil)
            }
            
        }) { (statusCode, _, error) in
            failure(statusCode, nil, error)
        }
        
    }
    
    class func request(method: HttpVerb, url: String, success: @escaping CompletionJSONSuccess, failure: @escaping CompletionJSONFailure) {
        self.request(method: method, url: url, parameters: nil, success: success, failure: failure)
    }
}
