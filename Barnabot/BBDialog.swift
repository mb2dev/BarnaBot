//
//  BBDialog.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

class BBDialog : NSObject {
    
    var next : BBNext {
        get {
            print("next getter with counter = \(counter)")
            let c = counter
            counter += 1
            return waterfall[c]
        }
    }
    var beginDialog : BBNext {
        get {
            print("beginDialog getter with counter = \(counter)")
            counter = 0;
            return self.next
        }
    }
    var waterfall : [BBNext]
    private var counter : Int = 0
    
    init(action : @escaping BBNext) {
        self.waterfall = [BBNext]()
        self.waterfall[0] = action;
    }
    
    init(waterfall : [BBNext]){
        self.waterfall = waterfall
    }

    override public var description: String{
        var result = ""
        result.append("BBDialog \n")
        result.append("- steps : \(self.waterfall.count)")
        return result
    }
    
}
