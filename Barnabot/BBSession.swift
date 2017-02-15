//
//  BBSession.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

/// Inspired by thread states
enum SessionState {
    case pending
    case new
    case running
    case terminated
}

class BBSession {
    
    static let sharedInstance : BBSession = BBSession()
    static let identifier : String = "BBSession"
    /*static func newInstance(_ sharedUserData : Bool?) -> BBSession {
        if let sud = sharedUserData {
            return BBSession(sharedUserData : sud)
        }
        return BBSession(sharedUserData: false)
    }*/
    static func newInstance() -> BBSession {
        return BBSession(sharedUserData: false)
    }
    static func newInstance(sharedUserData : Bool) -> BBSession {
        return BBSession(sharedUserData : sharedUserData)
    }
    
    var state : SessionState {
        get {
            if(_dialogStack.count > 0){
                return .running
            }else{
                return .pending
            }
        }
    }
    
    var human_feeling : Bool = true
    var delegate : BBSessionDelegate?
    /// Stores the result of a prompt to pass the value to the next dialog step
    var result : String = String()
    var sharedUserData : Bool = true
    
    private var userData : [String: Any]
    private var waiting_for_uinput : Bool = false
    private var _dialogStack : Stack<BBDialog> = Stack<BBDialog>()
    public var dialogStack : Stack<BBDialog> {
        get {
            var stack = Stack<BBDialog>()
            stack.items = _dialogStack.items.map { $0.copy() }
            return stack
        }
    }
    
    private convenience init(){
        self.init(sharedUserData : true)
    }
    
    private init(sharedUserData: Bool) {
        self.sharedUserData = sharedUserData
        if self.sharedUserData {
            let defaults = UserDefaults.standard
            if let data = defaults.dictionary(forKey: BBSession.identifier) {
                userData = data as! [String: Any]
            } else {
                userData = [String: Any]()
            }
        }else{
            userData = [String: Any]()
        }
    }
    
    /**
        Entry point to start interacting with the user.
     
        Invokes by default the dialog registered at the path **"/"**.
    */
    func beginConversation() -> BBSession {
        //print("beginConversation")
        return self.state == .running ? self : beginDialog(path: "/")
    }
    
    /**
        Starts the dialog registered at the path and push it on the top of the dialog stack
     */
    func beginDialog(path : String) -> BBSession {
        // TODO check waitin_for_uinput
        if let dialog : BBDialog = delegate?.botBuilder.dialogs[path] {
            self.safeBegin(dialog)
        }
        return self
    }
    
    /**
        Starts a dialog and push it on the top of the dialog stack
     */
    private func beginDialog(_ dialog: BBDialog) -> BBSession {
        //print("private beginDialog")
        let copy = dialog.copy()
        _dialogStack.push(copy)
        copy.beginDialog(self)
        return self
    }
    
    private func safeBegin(_ dialog : BBDialog){
        if(dialog != dialogStack.last){
            self.beginDialog(dialog)
        }
    }
    
    /**
        Persists the user data dictionary
    */
    private func saveUserData() -> BBSession {
        let defaults = UserDefaults.standard
        defaults.setValue(userData, forKey: BBSession.identifier)
        defaults.synchronize()
        return self
    }
    
    func saveUserData(value : Any, forKey: String) -> BBSession {
        userData.updateValue(value, forKey: forKey)
        return self.sharedUserData ? saveUserData() : self
    }
    
    func getUserData(_ key: String) -> Any?{
        return userData[key]
    }
    
    /*
     - todo: notify every session sharing data
    */
    func deleteUserData(){
        self.userData.removeAll(keepingCapacity: true)
        if self.sharedUserData {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: BBSession.identifier)
            defaults.synchronize()
        }
    }
    
    /**
        Ends the current dialog at the top of the stack.
     
        Removes the dialog from the stack.
     
        Call for the previous registered dialog.
    */
    func endDialog() -> BBSession {
        _dialogStack.pop()
        if(self.state != .pending){
            return  self.resume()
        }
        return self
    }
    
    /**
     Invokes the next step of the dialog at the top of the stack
     
     Should be private
     */
    func resume() -> BBSession {
        //print("resuming")
        if let dialog = _dialogStack.last {
            if let next = dialog.next {
                next(self)
            } else {
                self.endDialog()
            }
        }
        return self
    }
    
    func next() -> BBSession { return self.resume() }
    
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
    func send(_ msg : String) -> BBSession {
        if(self.human_feeling){
            self.delegate?.writing()
            let delay : NSNumber = NSNumber.init(value: Float(generateRandomNumber(min: 1000, max: 5000)) / Float(1000))
            let interval : TimeInterval = TimeInterval.init(delay)
            Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerSend), userInfo: msg, repeats: false)
        }else{
            if let deleg = delegate {
                deleg.send(msg)
            } else {
                print("BBSession has no delegate")
            }
        }
        return self
    }
    
    @objc func timerSend(timer : Timer) -> Void {
        
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
    func send(format : String, args : AnyObject...) -> BBSession {
        let msg : String = String(format: format, args)
        return send(msg)
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
                self.safeBegin(dialog)
            }
        }
        waiting_for_uinput = false
        self.result = msg
        self.resume()
    }
    
    /**
        Analyzes user input to detect intents
        
        - Returns: an array of matching registered BBIntentDialog
    */
    private func matches(text: String) -> [BBIntentDialog] {
        var result:[BBIntentDialog] = [BBIntentDialog]()
        for(regex,intentDialog) in (delegate?.botBuilder.intents)!{
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            //return results.map { nsString.substring(with: $0.range)}
            if (results.map { nsString.substring(with: $0.range)}).count > 0{
                result.append(intentDialog)
            }
        }
        return result
    }
}
