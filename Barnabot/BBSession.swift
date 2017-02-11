//
//  BBSession.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

class BBSession : NSObject {
    
    static let sharedInstance : BBSession = BBSession()
    static let identifier : String = "BBSession_"
    static func newInstance() -> BBSession {
        return BBSession()
    }
    
    var userData : [String: Any] = [String: Any]()
    var delegate : BBSessionDelegate?
    
    private var dialogStack : Stack<BBDialog> = Stack<BBDialog>()
    private var result : String = String()
    private var waiting_for_uinput : Bool = false
    
    private override init() {}
    
    /**
        Entry point to start interacting with the user.
     
        Invokes by default the dialog registered at the path **"/"**.
    */
    func beginConversation() -> Void {
        print("beginConversation")
        self.beginDialog(path: "/")
    }
    
    /**
        Starts the dialog registered at the path and push it on the top of the dialog stack
     */
    func beginDialog(path : String) -> Void {
        // TODO check waitin_for_uinput
        if let dialog : BBDialog = delegate?.botBuilder.dialogs[path] {
            self.beginDialog(dialog)
        }
    }
    
    /**
        Starts a dialog and push it on the top of the dialog stack
     */
    private func beginDialog(_ dialog: BBDialog) -> Void {
        dialogStack.push(dialog)
        dialog.beginDialog(self, nil)
    }
    
    /**
        Persists the user data dictionary
    */
    private func saveUserData() -> Void {
        let defaults = UserDefaults.standard
        
        for (key, value) in userData {
            defaults.setValue(value, forKey: BBSession.identifier + key )
        }
        
        defaults.synchronize()
    }
    
    /**
        Ends the current dialog at the top of the stack.
     
        Removes the dialog from the stack.
     
        Call for the previous registered dialog.
    */
    func endDialog() -> Void {
        dialogStack.pop()
        self.resume()
    }
    
    /**
        - todo:
     */
    func endDialogWithResult() -> Void {
        
    }
    
    /**
        - todo:
     */
    func cancelDialog() -> Void {
        
    }
    
    private func generateRandomNumber(min: Int, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
    
    /**
        Sends to delegate
     
        Gives a human feeling by applying a delay before sending a message
     */
    func send(_ msg : String) -> Void {
        let delay : NSNumber = NSNumber.init(value: generateRandomNumber(min: 500, max: 3000) / 1000)
        let interval : TimeInterval = TimeInterval.init(delay)
        Timer.init(timeInterval: interval, target: self, selector: #selector(timerSend), userInfo: msg, repeats: false)
//        if let deleg = delegate {
//            deleg.send(msg)
//        } else {
//            print("BBSession has no delegate")
//        }
    }
    
    func timerSend(timer : Timer) -> Void {
        
        if let deleg = delegate {
            if let msg = timer.userInfo {
                deleg.send(msg as! String)
            }
        } else {
            print("BBSession has no delegate")
        }
    }
    
    /**
        Sends with format
     */
    func send(format : String, args : AnyObject...) -> Void {
        let msg : String = String(format: format, args)
        send(msg)
    }
    
    /**
        Prompts for a simple answer
    */
    func promptText(_ msg: String) -> Void {
        waiting_for_uinput = true
        send(msg)
    }
    
    /**
        promptText with format
     
        - SeeAlso: `promptText(_ msg: String)`
    */
    func promptText(format : String, args : AnyObject...) -> Void {
        let msg : String = String(format: format, args)
        promptText(msg)
    }
    
    /**
        Prompts for a choice
     
        - SeeAlso: `promptText(_ msg: String)`
        - todo: bullets formatting (numbers, letters, ...)
     */
    func promptList(msg: String, _ list: [Any]) -> Void {
        waiting_for_uinput = true
        var msg_to_send = msg + "\n"
        for item in list {
            msg_to_send.append("\(item)")
        }
        send(msg_to_send)
    }
    
    /**
        Interface to deal with user input
    */
    func receive(_ msg : String) -> Void {
    
        // TODO envoyer à LUIS / recast.ai
        print("received msg : \(msg)")
        
        // ATTENTION à ne pas relancer un dialog déjà en cours 
        // (en recevant 2 fois "bonjour" à la suite par exemple)
        var found : [BBIntentDialog] = matches(text: msg)
        if found.count > 0 {
            found = found.sorted { $0.priority > $1.priority }
            if let dialog = found.first {
                if(dialog.id != dialogStack.last()?.id){
                    self.beginDialog(dialog)
                }
            }
        }
        waiting_for_uinput = false
        self.result = msg
        self.resume()
    }
    
    /**
        Invokes the next step of the dialog at the top of the stack
    */
    private func resume() -> Void {
        print("resuming")
        dialogStack.last()?.next(self, nil)
    }
    
    /**
        Analyzes user input to detect intents
        
        - Returns: an array of matching registered BBIntentDialog
    */
    private func matches(text: String) -> [BBIntentDialog] {
        var result:[BBIntentDialog] = [BBIntentDialog]()
        for(regex,value) in (delegate?.botBuilder.intents)!{
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            //return results.map { nsString.substring(with: $0.range)}
            if (results.map { nsString.substring(with: $0.range)}).count > 0{
                result.append(value)
            }
        }
        return result
    }
}
