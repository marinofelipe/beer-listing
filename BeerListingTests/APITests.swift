//
//  APITests.swift
//  BeerListing
//
//  Created by Felipe Marino on 31/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
@testable import BeerListing

enum TestingErrors: Error {
    case unknown
}

class APITests: XCTestCase {
    var alamofireManagerUnderTest: SessionManager!
    
    override func setUp() {
        super.setUp()
        alamofireManagerUnderTest = Alamofire.SessionManager.default
    }
    
    override func tearDown() {
        alamofireManagerUnderTest = nil
        super.tearDown()
    }
    
    // MARK: Alamofire testing
    
    //expecting return to be 200
    func testAlamofireManagerWithValidCall() {
        let url = "\(Constants.API.kBaseUrl)\(Constants.API.kGetBeers)?page=1&per_page=10"
        let promiseStatusCode = 200
        let promise = expectation(description: "received return status 200")
        alamofireManagerUnderTest.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                XCTAssertEqual(promiseStatusCode, response.response?.statusCode)
                promise.fulfill()
                break
            case .failure:
                XCTFail("Did not received return 200")
                break
            }
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
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
    
    //expecting result to be 200
    func testHTTPClientValidCall() {
        let promiseStatusCode: StatusCode = .success
        let promiseJSON = JSON.init([])
        let promise = expectation(description: "received status code 200 and response as JSON object")
        let url = "\(Constants.API.kBaseUrl)\(Constants.API.kGetBeers)?page=1&per_page=10"
        HTTPClient.request(method: .GET, url: url, parameters: nil, success: { (statusCode, jsonSerializer) in
            
            XCTAssertEqual(promiseStatusCode, statusCode)
            XCTAssertEqual(promiseJSON.type, jsonSerializer.object.type)
            promise.fulfill()
        }) { (satusCode, response, error) in
            XCTFail("Did not receive status code 200 and response as JSON object")
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
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
    
    // MARK: BeersHTTPClient tests
    
    //expecting success block
    func testBeersHTTPClientValidCall() {
        let promise = expectation(description: "Did receive answer on success block")
        BeersHTTPClient.getBeers(page: 1, success: { (beers) in
            promise.fulfill()
        }) { (_, _, _) in
            XCTFail("Did not receive receive answer on success block")
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
}
