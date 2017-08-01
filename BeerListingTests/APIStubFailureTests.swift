//
//  APIStubFailureTests.swift
//  BeerListing
//
//  Created by Felipe Marino on 01/08/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import XCTest
import Alamofire
import OHHTTPStubs
import SwiftyJSON
@testable import BeerListing

class APIStubFailureTests: XCTestCase {
    var alamofireManagerUnderTest: SessionManager!
    
    override func setUp() {
        super.setUp()
        alamofireManagerUnderTest = Alamofire.SessionManager.default
        OHHTTPStubs.setEnabled(true, for: alamofireManagerUnderTest.session.configuration)
        
        stub(condition: isHost("api.punkapi.com")) { _ in
            // Stub it with our "beers.json" stub file (which is in same bundle as self)
            guard let stubPath = OHPathForFile("beers.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return fixture(filePath: stubPath, status: 404, headers: nil)
        }
    }
    
    override func tearDown() {
        alamofireManagerUnderTest = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    // MARK: Alamofire testing
    
    //expecting return to be 404
    func testAlamofireManagerWithUnexistingEndpoint() {
        let url = "\(Constants.API.kBaseUrl)bears?page=1&per_page=10"
        let promiseStatusCode = 404
        let promise = expectation(description: "received return status 404")
        alamofireManagerUnderTest.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                XCTAssertEqual(promiseStatusCode, response.response?.statusCode)
                promise.fulfill()
                break
            case .failure:
                XCTFail("Did not received return 404")
                break
            }
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    //expecting failure result
    func testAlamofireManagerWithUnexistingDomain() {
        let url = "https://api.punkapi.com.br/beers?page=1&per_page=10"
        let error: TestingErrors = .unknown
        let promiseResult: Result<Any> = .failure(error)
        let promise = expectation(description: "received failure as result")
        alamofireManagerUnderTest.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                XCTFail("Did not received failure as return")
                break
            case .failure:
                XCTAssertEqual(promiseResult.isFailure, response.result.isFailure)
                promise.fulfill()
                break
            }
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    
    // MARK: HTTPClient tests
    
    //expecting result to be 404
    func testHTTPClientWithUnexistingEndpoint() {
        let promiseStatusCode: StatusCode = .notFound
        let promise = expectation(description: "received status code 404")
        let url = "\(Constants.API.kBaseUrl)bears?page=1&per_page=10"
        HTTPClient.request(method: .GET, url: url, parameters: nil, success: { (statusCode, jsonSerializer) in
            
            XCTFail("Did not receive status code 404")
            promise.fulfill()
        }) { (satusCode, response, error) in
            XCTAssertEqual(promiseStatusCode, satusCode)
            promise.fulfill()
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
}
