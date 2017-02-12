//
//  BBDialog.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

/// Inspired by thread states
enum DialogState {
    case pending
    case new
    case running
    case terminated
}

//https://developer.apple.com/reference/swift/equatable
class BBDialog : Equatable {
    
    let id : UUID
    var counter : Int = 0
    var state : DialogState {
        get {
            if(self.counter-1 >= waterfall.count){
                return .terminated
            }else if(self.counter == 0){
                return .new
            }else{
                return .running
            }
        }
    }
    var waterfall : [BBNext]
    // Pour pouvoir faire des comparaisons entre plusieurs instances de BBDialog
    let path : String
    var next : BBNext? {
        get {
            //print("next getter with counter = \(counter)")
            counter += 1
            return self.state == .terminated ? nil : waterfall[counter-1]
        }
    }
    var beginDialog : BBNext {
        get {
            //print("beginDialog getter with counter = \(counter)")
            return self.state == .running || self.state == .terminated ? waterfall[counter-1] : self.next!
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
    }
    
    init(_ path : String, waterfall : [BBNext]){
        // should force waterfall to have at least one element
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
        //print("BBDialog comparison")
        return lhs.path == rhs.path
    }
    
    func copy() -> BBDialog {
        return BBDialog(path, waterfall : waterfall)
    }
    
}
