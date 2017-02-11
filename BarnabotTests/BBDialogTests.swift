//
//  BBDialogTests.swift
//  Barnabot
//
//  Created by VAUTRIN on 11/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import XCTest
@testable import Barnabot

class BBDialogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testComparison() {
        let dialog1 = BBDialog("/", action: {
            (session : BBSession, next : BBDialog?) -> Void in
        })
        
        let dialog2 = dialog1.copy()
        
        let dialog3 = BBDialog("/foo", action: {
            (session : BBSession, next : BBDialog?) -> Void in
        })
        
        // comparison is done on "path"
        XCTAssert(dialog1 == dialog2)
        XCTAssert(dialog1 != dialog3)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
