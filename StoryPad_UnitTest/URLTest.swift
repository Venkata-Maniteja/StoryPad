//
//  URLTest.swift
//  StoryPad_UnitTest
//
//  Created by Venkata Nandamuri on 23/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import XCTest

@testable import Wattpad_Test

class URLTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   
    func testIfURLIsValid(){
        let session = URLSession()
        let manager = StoryManager(session)
        manager.storiesOffset = 0
        manager.storyLimitPerRequest = 50
        let origURL = URL(string:"https://www.wattpad.com/api/v3/stories?offset=0&limit=50&fields=stories(id,title,cover,user)")
        XCTAssertEqual(manager.buildURL(), origURL, "URLs did not match")
    }

}
