//
//  BBBuilder.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

class BBBuilder {
    
    let botName : String
    
    var dialogs : [String: BBDialog] = [String: BBDialog]()
    func dialog(path : String, dialog : BBDialog) -> BBBuilder {
        dialogs.updateValue(dialog, forKey: path)
        return self
    }
    
    init(_ name : String){
        botName = name
    }
}
