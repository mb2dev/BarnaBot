//
//  GVCopying.swift
//  Barnabot
//
//  Created by VAUTRIN on 11/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/25645090/protocol-func-returning-self
protocol GVCopying {
    func copy() -> GVCopying
}
