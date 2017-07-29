//
//  JSONSerializer.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import SwiftyJSON

typealias CompletionJSONSuccess = (_ statusCode: Int, _ response: JSONSerializer) -> Void
typealias CompletionJSONFailure = (_ statusCode: Int, _ response: Any?, _ error: Error?) -> Void

class JSONSerializer {
    
    var object: JSON
    
    init(_ object: Any) {
        self.object = JSON(object)
    }
    
    public func null() -> Bool {
        if let _ = object.null {
            return true
        }
        return false
    }
}
