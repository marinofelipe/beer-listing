//
//  HTTPClient.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import Alamofire

enum HttpVerb: String {
    case GET, POST, PUT, DELETE
}

enum StatusCode: Int {
    case offline = 999
    case notFound = 404
    case badRequest = 500
    case success = 200
    case unknown = 666
}

typealias CompletionApiSuccess = (_ statusCode: StatusCode, _ response: Any?) -> Void
typealias CompletionApiFailure = (_ statusCode: StatusCode, _ response: Any?, _ error: Error?) -> Void

class HTTPClient {

    fileprivate class func requestAlamofire(method: HttpVerb, url: String,
                                            parameters: [String : AnyObject]?,
                                            success: @escaping CompletionApiSuccess,
                                            failure: @escaping CompletionApiFailure) {
        
        guard Reachability.isConnected() else {
            failure(.offline, nil, nil)
            return
        }
        
        let alamofireMethod = Alamofire.HTTPMethod(rawValue: method.rawValue)!
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        manager.request(url, method: alamofireMethod, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            let value = response.result.value
            
            //Handling failure on responses
            switch response.result {
            case .failure(let error):
                failure(.unknown, value, error)
                break
            default:
                break
            }
            
            //Handling different types of success responses, as 200, 404..
            if let code = response.response?.statusCode, let value = value {
                switch code {
                case StatusCode.success.rawValue:
                    success(.success, value)
                default:
                    if let statusCode = StatusCode(rawValue: code) {
                        failure(statusCode, value, response.error)
                    } else {
                        failure(.unknown, value, response.error)
                    }
                }
            }
        }
    }
    
    class func request(method: HttpVerb, url: String,
                       parameters: [String : AnyObject]?,
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
}
