//
//  BBIntentDialogTests.swift
//  Barnabot
//
//  Created by VAUTRIN on 11/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import XCTest
@testable import Barnabot

class BBIntentDialogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testComparison() {
        do{
            let regex1 = try NSRegularExpression.init(pattern: "^hello")
            let dialog1 = BBIntentDialog(regex1, action: {
                (session : BBSession) -> Void in
            }, priority: 0)
        
            let regex2 = try NSRegularExpression.init(pattern: "^hello")
            let dialog2 = dialog1.copy()
        
            let regex3 = try NSRegularExpression.init(pattern: "^help")
            let dialog3 = BBIntentDialog(regex3, action: {
                (session : BBSession) -> Void in
            }, priority: 0)
            
            // comparison is done on "path"
            XCTAssert(regex1 == regex2)
            XCTAssert(dialog1 == dialog2)
            XCTAssert(dialog1 != dialog3)
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }

    }
    
}
