//
//  BeersViewControllerTests.swift
//  BeerListing
//
//  Created by Felipe Marino on 31/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import XCTest
import SwiftyJSON
import ObjectMapper
@testable import BeerListing

class BeersViewControllerTests: XCTestCase {
    var underTestController: BeersViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        underTestController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.kBeersVCId) as! BeersViewController
        
        UIApplication.shared.keyWindow?.rootViewController = underTestController
        
        XCTAssertNotNil(underTestController.preloadView())
    }
    
    override func tearDown() {
        underTestController = nil
        super.tearDown()
    }
    
    //test if components are as expected on load
    func testIfViewsAreCorrectlyConfigured() {
        XCTAssertEqual(underTestController.noDataLabel.isHidden, true)
        XCTAssertEqual(underTestController.activityIndicator.isAnimating, true)
        XCTAssertEqual(underTestController.automaticallyAdjustsScrollViewInsets, false)
        XCTAssertNotNil(underTestController.tableView.refreshControl)
    }
    
    //test how data states after fetch
    func testFetchingBeerReturn() {
        XCTAssertEqual(underTestController.beers.count, 0)
        let promise = expectation(description: "received array of beer")
        BeersHTTPClient.getBeers(page: 1, success: { beers in

            XCTAssertEqual(self.underTestController.beers.count, 10)
            promise.fulfill()
        }) { (_, _, _) in
            XCTFail("Did not receive array of beer")
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    // Performance
    func test_StartDownload_Performance() {
        measure {
            self.underTestController.fetchBeers()
        }
    }
}
