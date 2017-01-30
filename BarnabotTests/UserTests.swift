//
//  UserTests.swift
//  FastlaneDemo
//
//  Created by Benoit BRIATTE on 04/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import XCTest
@testable import Barnabot

class UserTests: XCTestCase {

    func testUserInit() {
        let u = User(login: "hello", password: "azertyuiop")
        XCTAssertEqual(u.login, "hello")
        XCTAssertEqual(u.password, "azertyuiop")
    }

    func testUserDescription() {
        let u = User(login: "jean", password: "dshbfggdqs")
        XCTAssertEqual(u.description, "[User jean dshbfggdqs]")
    }

}
