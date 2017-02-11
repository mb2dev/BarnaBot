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
    var waterfall : [BBNext]
    private var counter : Int = 0
    
    var count : Int
    // Pour pouvoir faire des comparaisons entre plusieurs instances de BBDialog
    let path : String
    var next : BBNext? {
        get {
            print("next getter with counter = \(counter)")
            let c = counter
            counter += 1
            return c+1 > count ? nil : waterfall[c]
        }
    }
    var beginDialog : BBNext {
        get {
            print("beginDialog getter with counter = \(counter)")
            counter = 0;
            return self.next!
        }
    }
    
    func resume(_ session : BBSession,_ nextDialog : BBDialog?){
        if let next = self.next {
            next(session, nextDialog)
        }
    }
    
    convenience init(_ path : String, action : @escaping BBNext) {
        self.init(path, waterfall: [BBNext]())
        self.waterfall.append(action);
        self.count = 1
    }
    
    init(_ path : String, waterfall : [BBNext]){
        // should force waterfall to have at least one element
        self.path = path
        self.waterfall = waterfall
        self.count = waterfall.count
        self.id = UUID()
    }

    public var description: String{
        var result = ""
        result.append("BBDialog \n")
        result.append("- steps : \(self.waterfall.count)")
        return result
    }
    
    static func == (lhs: BBDialog, rhs: BBDialog) -> Bool {
        print("BBDialog comparison")
        return lhs.path == rhs.path
    }
    
    func copy() -> BBDialog {
        return BBDialog(path, waterfall : waterfall)
    }
    
}
