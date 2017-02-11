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
    
    init(_ session : BBSession, _ builder : BBBuilder){
        botSession = session
        botSession.human_feeling = false
        botBuilder = builder
        session.delegate = self
    }
    
    func send(_ msg: String) {
        print(msg)
        last_msg = msg
    }
}
