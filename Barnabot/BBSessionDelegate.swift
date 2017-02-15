//
//  BBSessionDelegate.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

protocol BBSessionDelegate {
    var botSession : BBSession { get set }
    var botBuilder : BBBuilder { get set }
    func send(_ msg : String) -> Void
    func writing() -> Void
}
