//
//  JodelChallengeTests.swift
//  JodelChallengeTests
//
//  Created by Michal Ciurus on 21/09/2017.
//  Copyright © 2017 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class JodelChallengeTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    @objc func testFlickrApi() {
        // Create expectation in order to unit test asynchronously
        let myExpectation = expectation(description: "Fetch data from Flickr")
        
        // Call fetch function from NetworkAPI
        FlickrApi.fetchPhotos(withPageNumber: 1, andCompletion: { (responseArray, error) in
//            usleep(3000000) // -> see if test fails if timeout is reached
            
            // Avoid force unwrapping
            guard let responseArray = responseArray else {
                XCTFail("No response")
                return
            }
            
            // Asssert a few properties on the returned data
            XCTAssertTrue(responseArray.count == 10)
            let myFirstObject = responseArray.first!
            XCTAssertTrue(myFirstObject["url"] != nil)
            XCTAssertTrue(myFirstObject["title"] != nil)
            XCTAssertTrue(myFirstObject["id"] != nil)
            
            // Fullfill expectation if all assertions are met
            myExpectation.fulfill()
        })
        
        // Fail test after 2 seconds wait time
        waitForExpectations(timeout: 2, handler: { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        })
    }
    
// UI Testing probably not working because the imageview is not actually layed out.
// How would one unit test ui components?
    
//    func testFeedCell() {
//
//        // I chose to get an image url from a placeholder page instead of asynchronously calling the
//        // api and using an image from the response.
//        // Test will obviously fail if placeholder.com api goes offline
////        let myData: Dictionary<AnyHashable, Any> = ["url": "https://via.placeholder.com/250.png", "title": "mytitle"]
//
//        // For some reason creating the cell using this dictionary the force conversion to url in the FeedCell fails.
//        // Even though objects in the debugger are identical.
////        let myData: Dictionary<AnyHashable, Any> = ["url": "https://farm66.static.flickr.com/65535/48239102577_329c07f3a7_m.jpg", "title": "mytitle"]
//
//        let myFeedCell = FeedCell.init()
//        myFeedCell.configure(with: myData)
//    }
}
