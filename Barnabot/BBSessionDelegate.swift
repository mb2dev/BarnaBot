//
//  BBSessionDelegate.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

protocol BBSessionDelegate {
    func send(_ msg : String) -> Void
    func receive(_ msg : String) -> Void
}
