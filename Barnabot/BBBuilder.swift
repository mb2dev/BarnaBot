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
    var intents : [NSRegularExpression: BBIntentDialog] = [NSRegularExpression: BBIntentDialog]()
    
    init(_ name : String){
        botName = name
    }
    
    func dialog(path : String, dialog : BBDialog) -> BBBuilder {
        dialogs.updateValue(dialog, forKey: path)
        return self
    }
    
    func dialog(path : String, _ waterfall : [BBNext]) -> BBBuilder {
        dialogs.updateValue(BBDialog(path, waterfall:  waterfall), forKey: path)
        return self
    }
    
    /************************* String as Regex *******************************/
    
    // with redir
    func matches(regex:String, redir:String, priority:Int) ->BBBuilder{
        return matches(regex: stringToRegex(regex), redir: redir, priority: priority)
    }
    
    // with waterfall
    func matches(regex:String, priority:Int, _ waterfall : [BBNext]) ->BBBuilder{
        return matches(regex: stringToRegex(regex), priority: priority, waterfall)
    }
    
    func stringToRegex(_ regex: String) -> NSRegularExpression{
        do {
            let reg = try NSRegularExpression(pattern: regex)
            return reg
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
        return NSRegularExpression()
    }
    
    /************************* Regex as Regex *******************************/
    
    // with redir
    func matches(regex:NSRegularExpression, redir:String, priority:Int) ->BBBuilder{
        intents.updateValue(BBIntentDialog(regex, redir: redir, priority: priority), forKey: regex)
        return self
    }
    
    // with waterfall
    func matches(regex:NSRegularExpression, priority:Int, _ waterfall : [BBNext]) ->BBBuilder{
        intents.updateValue(BBIntentDialog(regex, waterfall: waterfall, priority: priority), forKey: regex)
        return self
    }
    
    
    
}
