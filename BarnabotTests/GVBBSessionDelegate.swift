//
//  GVBBSessionDelegate.swift
//  Barnabot
//
//  Created by VAUTRIN on 11/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation
@testable import Barnabot

class GVBBSessionDelegate : BBSessionDelegate {
    
    var botSession : BBSession
    var botBuilder : BBBuilder
    var last_msg : String = String()
    var writes : Bool = false
    // for asynchronous testing
    var completionHandler : (() -> Void)?
    
    convenience init(_ session : BBSession, _ builder : BBBuilder){
        self.init(session, builder, human_feeling : false)
    }
    
    init(_ session : BBSession, _ builder : BBBuilder, human_feeling : Bool){
        botSession = session
        botSession.flags["human_feeling"] = human_feeling
        botBuilder = builder
        session.delegate = self
    }

    
    func send(_ msg: String) {
        writes = false
        print(msg)
        last_msg = msg
        if let handler = completionHandler {
            handler()
        }
    }
    
    func writing(){
        writes = true
    }
    
    func answer(_ msg : String){
        botSession.receive(msg)
    }
}
