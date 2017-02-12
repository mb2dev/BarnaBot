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
        XCTAssertEqual(botSession.dialogStack.count, 0)
        
        /*******************************************************/
        
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        botBuilder
            .dialog(path: "/", [{(session : BBSession, next : BBDialog?) -> Void in
                session.send("foo")
            }])
        
        GVBBSessionDelegate(botSession, botBuilder)
        botSession.beginConversation()
        
        XCTAssertEqual(botSession.dialogStack.count, 1)
        
        /*********************************************************/
        
        //Subsequent calls does nothing
        botSession.beginConversation()
        XCTAssertEqual(botSession.dialogStack.count, 1)
        
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
        
        XCTAssertEqual(botSession.dialogStack.count, 0)
    }
    
    func testWriting(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        botBuilder
            .dialog(path: "/foo", [{(session : BBSession, next : BBDialog?) -> Void in
                session.send("bar")
                }])
        
        let delegate  = GVBBSessionDelegate(botSession, botBuilder, human_feeling: true)
        botSession.beginDialog(path: "/foo")
        
        // human_feeling = true => a delay is applied
        XCTAssertEqual(delegate.last_msg, "")
        XCTAssert(delegate.writes)
    }
    
    /// ATTENTION ne pas confondre la fonction 'send' et la fonction 'promptText'
    func testCompleteCase1(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        botBuilder
            .dialog(path: "/", [{(session : BBSession, next : BBDialog?) -> Void in
                if let name = session.userData["name"] {
                    if let _next = next {
                        _next.next!(session, nil)
                    }
                } else {
                    session.beginDialog(path: "/profile")
                }
                },
                {(session : BBSession, next : BBDialog?) -> Void in
                    if let name = session.userData["name"] {
                        session.send("Hello \(name)!")
                        session.endDialog()
                    }
                }])
            .dialog(path: "/profile", [{(session : BBSession, next : BBDialog?) -> Void in
                
                session.promptText("Hi! What is your name?")
                
                },{(session : BBSession, next : BBDialog?) -> Void in
                    session.userData.updateValue(session.result, forKey: "name")
                    session.endDialog()
                }])
        
        botBuilder.dialog(path: "/end", [{(session : BBSession, next : BBDialog?) -> Void in
            session.promptText("OK! See you tomorrow?")
        },{(session : BBSession, next : BBDialog?) -> Void in
            session.endDialog()
        }])
        
        botBuilder.matches(regex: "bonjour", redir: "/",priority: 0);
        botBuilder.matches(regex: "au revoir", redir: "/end",priority: 0);
        
        // botSession.human_feeling is set to false in the GVBBSessionDelegate constructor
        let delegate  = GVBBSessionDelegate(botSession, botBuilder, human_feeling: false)
        
        /***************************************************************/
        
        botSession.beginConversation()
        XCTAssertEqual(delegate.last_msg, "Hi! What is your name?")
        let lastDialog = botSession.dialogStack.last!
        let lastDialogInBuilder = botBuilder.dialogs["/profile"]
        XCTAssertEqual(lastDialog.path, "/profile")
        XCTAssertEqual(lastDialog.counter, 1)
        XCTAssertEqual(lastDialogInBuilder?.counter, 0)
        
        delegate.answer("FOO")
        
        // A ce stade, base dialog a déjà été ejecté du stack
        //let baseDialog = botSession.dialogStack.last!
        //XCTAssertEqual(baseDialog.path, "/")
        
        XCTAssertEqual(delegate.last_msg, "Hello FOO!")
        XCTAssertEqual(botSession.userData["name"] as! String, "FOO")
        // Tous les dialogues sont résolus
        XCTAssertEqual(botSession.dialogStack.count, 0)
        
        /***************************************************************/
    }
    
}
