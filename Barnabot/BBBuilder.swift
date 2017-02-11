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
    var intents : [String: BBIntentDialog] = [String: BBIntentDialog]()
    
    func dialog(path : String, dialog : BBDialog) -> BBBuilder {
        dialogs.updateValue(dialog, forKey: path)
        return self
    }
    func matches(regex:String,idDialog:String, priority:Int) ->BBBuilder{
        intents.updateValue(BBIntentDialog(idDialog: idDialog, priority:priority), forKey: regex)
        return self
    }
    
    
    
    init(_ name : String){
        botName = name
    }
}
