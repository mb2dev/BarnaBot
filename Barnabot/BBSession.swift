//
//  BBSession.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

class BBSession {
    
    static let sharedInstance : BBSession = BBSession()
    static let identifier : String = "BBSession_"
    
    var userData : [String: Any] = [String: Any]()
    // TODO BBDialog property
    var dialogData : [String: Any] = [String: Any]()
    var conversationData : [String: Any] = [String: Any]()
    
    var dialogStack : Stack<BBDialog> = Stack<BBDialog>()
    var botBuilder : BBBuilder?
    var delegate : BBSessionDelegate?
    
    var result : String = String()
    var waiting_for_uinput : Bool = false
    
    private init() {}
    
    func beginConversation() -> Void {
        print("beginConversation")
        if let dialog : BBDialog = botBuilder?.dialogs["/"] {
            dialogStack.push(dialog)
            dialog.beginDialog(self, nil)
        } else {
            print("no dialog for path \"/\"")
        }
    }
    
    // TODO restricted access
    func beginDialog(path : String) -> Void {
        // TODO check waitin_for_uinput
        
        if let dialog : BBDialog = botBuilder?.dialogs[path] {
            dialogStack.push(dialog)
            dialog.beginDialog(self, nil)
        }
    }
    
    func saveUserData() -> Void {
        let defaults = UserDefaults.standard
        
        for (key, value) in userData {
            defaults.setValue(value, forKey: BBSession.identifier + key )
        }
        
        defaults.synchronize()
    }
    
    func endDialog() -> Void {
        dialogStack.pop()
        self.resume()
    }
    
    func endDialogWithResult(result : String){
        
    }
    
    func cancelDialog() -> Void {
        
    }
    
    func send(_ msg : String) -> Void {
        if let deleg = delegate {
            deleg.send(msg)
        } else {
            print("BBSession has no delegate")
        }
    }
    
    func send(format : String, args : AnyObject...) -> Void {
        let msg : String = String(format: format, args)
        send(msg)
    }
    
    func promptText(_ msg: String) -> Void {
        waiting_for_uinput = true
        send(msg)
    }
    
    func promptList(_ msg: String) -> Void {
        waiting_for_uinput = true
    }
    
    func receive(_ msg : String) -> Void {
        // TODO analyser le message pour détecter une "Intent"
        // TODO envoyer à LUIS / recast.ai
        print("received msg : \(msg)")
        var find = matches(text: msg)
        if find.count > 0{
           find = find.sorted { $0.priority > $1.priority }
            beginDialog(path: (find.first?.idDialog)!)
        }
        waiting_for_uinput = false
        self.result = msg
        self.resume()
    }
    
    private func resume() -> Void {
        print("resuming")
        dialogStack.last()?.next(self, nil)
    }
    
    func matches(text: String) -> [BBIntentDialog] {
        var result:[BBIntentDialog] = [BBIntentDialog]()
        for(key,value) in (botBuilder?.intents)!{
        do {
            let regex = try NSRegularExpression(pattern: key)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            //return results.map { nsString.substring(with: $0.range)}
            if (results.map { nsString.substring(with: $0.range)}).count > 0{
                result.append(value)
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return result
        }
        }
        return result
    }
}
