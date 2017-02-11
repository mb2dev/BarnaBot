//
//  BBDialog.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

//https://developer.apple.com/reference/swift/equatable
class BBDialog : Equatable {
    
    private let id : UUID
    let path : String
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
    
    convenience init(_ path : String, action : @escaping BBNext) {
        self.init(path, waterfall: [BBNext]())
        self.waterfall.append(action);
    }
    
    init(_ path : String, waterfall : [BBNext]){
        self.path = path
        self.waterfall = waterfall
        self.id = UUID()
    }

    public var description: String{
        var result = ""
        result.append("BBDialog \n")
        result.append("- steps : \(self.waterfall.count)")
        return result
    }
    
    static func == (lhs: BBDialog, rhs: BBDialog) -> Bool {
        return lhs.id == rhs.id
    }
    
    func copy() -> BBDialog {
        return BBDialog(path, waterfall : waterfall)
    }
    
}
