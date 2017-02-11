//
//  BBSessionTests.swift
//  Barnabot
//
//  Created by VAUTRIN on 11/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import XCTest

/**
a unit test target can access any internal entity,
if you mark the import declaration for a product module with the @testable attribute
and compile that product module with testing enabled
 */
@testable import Barnabot

class BBSessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBeginConversation() {
        
        let botSession = BBSession.newInstance()
        
        // does not crash
        botSession.beginConversation()
        XCTAssert(botSession.dialogStack.count == 0)
        
        /*******************************************************/
        
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        botBuilder
            .dialog(path: "/", [{(session : BBSession, next : BBDialog?) -> Void in
                session.send("foo")
            }])
        
        GVBBSessionDelegate(botSession, botBuilder)
        botSession.beginConversation()
        
        XCTAssert(botSession.dialogStack.count == 1)
        
        /*********************************************************/
        
        //Subsequent calls does nothing
        botSession.beginConversation()
        XCTAssert(botSession.dialogStack.count == 1)
        
    }//testBeginConversation
    
    func testBeginDialog(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        botBuilder
            .dialog(path: "/foo", [{(session : BBSession, next : BBDialog?) -> Void in
                session.send("bar")
            }])
        
        // botSession.human_feeling is set to false in the GVBBSessionDelegate constructor
        let delegate  = GVBBSessionDelegate(botSession, botBuilder)
        botSession.beginDialog(path: "/foo")
        
        XCTAssert(botSession.dialogStack.count == 1)
        XCTAssertEqual(delegate.last_msg, "bar")
    }
    
    func testResume(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        botBuilder
            .dialog(path: "/foo", [{(session : BBSession, next : BBDialog?) -> Void in
                session.send("bar")
                }])
        
        // botSession.human_feeling is set to false in the GVBBSessionDelegate constructor
        let delegate  = GVBBSessionDelegate(botSession, botBuilder)
        botSession
            .resume()
            .resume()
        
        botSession
            .beginDialog(path: "/foo")
            .resume()
            .resume()
        
        XCTAssert(botSession.dialogStack.count == 0)
    }
    
    func testWriting(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        botBuilder
            .dialog(path: "/foo", [{(session : BBSession, next : BBDialog?) -> Void in
                session.send("bar")
                }])
        
        // botSession.human_feeling is set to false in the GVBBSessionDelegate constructor
        let delegate  = GVBBSessionDelegate(botSession, botBuilder, human_feeling: true)
        botSession.beginDialog(path: "/foo")
        
        // human_feeling = true => a delay is applied
        XCTAssertEqual(delegate.last_msg, "")
        XCTAssert(delegate.writes)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
