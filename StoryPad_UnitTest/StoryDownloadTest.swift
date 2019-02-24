//
//  StoryDownloadTest.swift
//  StoryPad_UnitTest
//
//  Created by Venkata Nandamuri on 23/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import XCTest

@testable import Wattpad_Test

class StoryDownloadTest: XCTestCase {
    
    var manager : StoryManager!
    var sesionUnderTest : URLSession!
    
    override func setUp() {
        super.setUp()
        sesionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        manager = StoryManager(sesionUnderTest)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_get_should_return_data() {
        let expectedData = "{}".data(using: .utf8)
        
        var actualData: Data?
        sesionUnderTest.dataTask(with: URLRequest(url: manager.buildURL()!), completionHandler: { data, response, error in
           actualData = data
           XCTAssertNotNil(actualData)
        }).resume()
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToiTunesGetsHTTPStatusCode200() {
       
        let url = manager.buildURL()
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sesionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }

    

}
