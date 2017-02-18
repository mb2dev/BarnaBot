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
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: BBSession.identifier)
        defaults.synchronize()
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
        _ = botBuilder
            .dialog(path: "/", [{(session : BBSession) -> Void in
                _ = session.send("foo")
            }])
        
        _ = GVBBSessionDelegate(botSession, botBuilder)
        _ = botSession.beginConversation()
        
        XCTAssertEqual(botSession.dialogStack.count, 1)
        
        /*********************************************************/
        
        //Subsequent calls does nothing
        _ = botSession.beginConversation()
        XCTAssertEqual(botSession.dialogStack.count, 1)
        
    }//testBeginConversation
    
    func testBeginDialog(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        _ = botBuilder
            .dialog(path: "/foo", [{(session : BBSession) -> Void in
                _ = session.send("bar")
            }])
        
        // botSession.human_feeling is set to false in the GVBBSessionDelegate constructor
        let delegate  = GVBBSessionDelegate(botSession, botBuilder)
        _ = botSession.beginDialog(path: "/foo")
        
        XCTAssert(botSession.dialogStack.count == 1)
        XCTAssertEqual(delegate.last_msg, "bar")
    }
    
    func testResume(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        _ = botBuilder
            .dialog(path: "/foo", [{(session : BBSession) -> Void in
                _ = session.send("bar")
            }])
        
        // botSession.human_feeling is set to false in the GVBBSessionDelegate constructor
        _ = GVBBSessionDelegate(botSession, botBuilder)
        _ = botSession
            .resume()
            .resume()
        
        _ = botSession
            .beginDialog(path: "/foo")
            .resume()
            .resume()
        
        XCTAssertEqual(botSession.dialogStack.count, 0)
    }
    
    func testWriting(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        _ = botBuilder
            .dialog(path: "/foo", [{(session : BBSession) -> Void in
                _ = session.send("bar")
            }])
        
        let delegate  = GVBBSessionDelegate(botSession, botBuilder, human_feeling: true)
        _ = botSession.beginDialog(path: "/foo")
        
        // human_feeling = true => a delay is applied
        XCTAssertEqual(delegate.last_msg, "")
        XCTAssert(delegate.writes)
    }
    
    // Asynchronous test
    func testHumanFeeling(){
        let delayedRepsonseExpectation : XCTestExpectation = expectation(description: "delayed response")
        
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        
        _ = botBuilder
            .dialog(path: "/foo", [{(session : BBSession) -> Void in
                _ = session.send("bar")
            }])
        
        // human_feeling = true => a delay is applied
        let delegate  = GVBBSessionDelegate(botSession, botBuilder, human_feeling: true)
        _ = botSession.beginDialog(path: "/foo")
        delegate.completionHandler = {() -> Void in
            delayedRepsonseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: {(err : Error?) -> Void in
            // NOTHING
        })
    }
    
    func testMatching(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        _ = botBuilder.dialog(path: "/end", [{(session : BBSession) -> Void in
                _ = session.send("See U")
            },{(session : BBSession) -> Void in
                _ = session.endDialog()
            }])
            .dialog(path: "/", [{(session : BBSession) -> Void in
                _ = session.send("Hello!").endDialog()
            }])
        
        _ = botBuilder
            .matches(regex: "^bonjour", redir: "/",priority: 0)
            .matches(regex: "^au revoir", redir: "/end",priority: 0)
            .matches(regex: "^help$", priority: 0, [{(session : BBSession) -> Void in
                _ = session.send("Bot Help")
            }])
        
        let delegate  = GVBBSessionDelegate(botSession, botBuilder, human_feeling: false)
        
        botSession.receive("bonjour Barnabot")
        XCTAssertEqual(delegate.last_msg, "Hello!")
        
        botSession.receive("au revoir Barnabot")
        XCTAssertEqual(delegate.last_msg, "See U")
        
        botSession.receive("help Barnabot") //does not match
        XCTAssertEqual(delegate.last_msg, "See U")
        
        botSession.receive("help") // match
        XCTAssertEqual(delegate.last_msg, "Bot Help")
    }
    
    func testPersistence(){
        
        // sharedUserData = false
        let botSession1 = BBSession.newInstance()
        XCTAssertNil(botSession1.getUserData("name"))
        _ = botSession1.saveUserData(value: "foo", forKey: "name") //does not persist
        // is saved in local dictionary
        XCTAssertEqual(botSession1.getUserData("name") as! String, "foo")
        
        // sharedUserData = false
        let botSession2 = BBSession.newInstance()
        XCTAssertNil(botSession2.getUserData("name"))
        _ = botSession2.saveUserData(value: "bar", forKey: "name") //does not persist
        // is saved in local dictionary
        XCTAssertEqual(botSession2.getUserData("name") as! String, "bar")
        
        let botSession3 = BBSession.newInstance(sharedUserData : true)
        XCTAssertNil(botSession3.getUserData("name"))
        _ = botSession3.saveUserData(value: "quux", forKey: "name") //persists
        XCTAssertEqual(BBSession.sharedInstance.getUserData("name") as! String, "quux")
        
        botSession3.deleteUserData()
        XCTAssertNil(botSession3.getUserData("name"))
        // sharedInstance n'est pas notifiée du changement dans botSession3
        XCTAssertEqual(BBSession.sharedInstance.getUserData("name") as! String, "quux")
        XCTAssertNil(BBSession.newInstance(sharedUserData : true).getUserData("name"))
    }
    
    /// ATTENTION ne pas confondre la fonction 'send' et la fonction 'promptText'
    func testCompleteCase1(){
        let botSession = BBSession.newInstance()
        let botBuilder : BBBuilder = BBBuilder("Barnabot")
        _ = botBuilder
            .dialog(path: "/", [{(session : BBSession) -> Void in
                if session.getUserData("name") != nil {
                    _ = session.next()
                } else {
                    _ = session.beginDialog(path: "/profile")
                }
                },
                {(session : BBSession) -> Void in
                    if let name = session.getUserData("name") {
                        _ = session.send("Hello \(name)!").endDialog()
                    }
                }])
            .dialog(path: "/profile", [{(session : BBSession) -> Void in
                
                session.promptText("Hi! What is your name?")
                
                },{(session : BBSession) -> Void in
                    _ = session
                        .saveUserData(value: session.result, forKey: "name")
                        .endDialog()
                }])
        
        _ = botBuilder.dialog(path: "/end", [{(session : BBSession) -> Void in
            _ = session.send("See U")
        },{(session : BBSession) -> Void in
            _ = session.endDialog()
        }])
        
        // botSession.human_feeling is set to false in the GVBBSessionDelegate constructor
        let delegate  = GVBBSessionDelegate(botSession, botBuilder, human_feeling: false)
        
        /***************************************************************/
        
        botSession.beginConversation()
        XCTAssertEqual(delegate.last_msg, "Hi! What is your name?")
        let lastDialog = botSession.dialogStack.last!
        let lastDialogInBuilder = botBuilder.dialogs["/profile"]
        XCTAssertEqual(lastDialog.path, "/profile")
        //XCTAssertEqual(lastDialog.counter, 1)
        XCTAssertEqual(lastDialogInBuilder?.counter, 0)
        
        delegate.answer("FOO")
        
        // A ce stade, base dialog a déjà été ejecté du stack
        //let baseDialog = botSession.dialogStack.last!
        //XCTAssertEqual(baseDialog.path, "/")
        
        XCTAssertEqual(delegate.last_msg, "Hello FOO!")
        XCTAssertEqual(botSession.getUserData("name") as! String, "FOO")
        // Tous les dialogues sont résolus
        XCTAssertEqual(botSession.dialogStack.count, 0)
        
        /***************************************************************/
    }
    
}
