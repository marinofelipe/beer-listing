//
//  AlamofireStubTests.swift
//  BeerListing
//
//  Created by Felipe Marino on 01/08/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
import SwiftyJSON
@testable import BeerListing

class APIStubSuccessTests: XCTestCase {
    var alamofireManagerUnderTest: SessionManager!
    var underTestController: BeersViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        underTestController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.kBeersVCId) as! BeersViewController
        UIApplication.shared.keyWindow?.rootViewController = underTestController
        XCTAssertNotNil(underTestController.preloadView())
        
        alamofireManagerUnderTest = Alamofire.SessionManager.default
        
        OHHTTPStubs.setEnabled(true, for: alamofireManagerUnderTest.session.configuration)
        stub(condition: isHost("api.punkapi.com")) { _ in
            // Stub it with our "beers.json" stub file (which is in same bundle as self)
            guard let stubPath = OHPathForFile("beers.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return fixture(filePath: stubPath, status: 200, headers: nil)
        }
    }
    
    override func tearDown() {
        alamofireManagerUnderTest = nil
        underTestController = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    // MARK: Alamofire testing
    
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
    
    //test how data states after fetch
    func testFetchingBeerReturn() {
        XCTAssertEqual(underTestController.beers.count, 0)
        let promise = expectation(description: "received array of beer")
        BeersHTTPClient.getBeers(page: 1, success: { beers in
            self.underTestController.beers = beers
            XCTAssertEqual(self.underTestController.beers.count, 10)
            promise.fulfill()
        }) { (_, _, _) in
            XCTFail("Did not receive array of beer")
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
}
