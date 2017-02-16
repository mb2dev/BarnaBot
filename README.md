[![Build Status](https://travis-ci.org/mb2dev/BarnaBot.svg?branch=master)](https://travis-ci.org/mb2dev/BarnaBot)
# BarnaBot

```swift
class ChatViewController: JSQMessagesViewController, BBSessionDelegate {

	…
	let botBuilder : BBBuilder = BBBuilder("Barnabot")
       let botSession : BBSession = BBSession.sharedInstance

	func send(_ msg: String) {
        	print("send from BBSessionDelegate")
        	let message = JSQMessage(senderId: botBuilder.botName, senderDisplayName: 	botBuilder.botName, date: Date.init(), text: msg as String!)
        	self.messages.append(message!)
        	self.finishSendingMessage(animated: true)
    	}

	// TODO inutile
       func receive(_ msg : String) {
       		botSession.receive(msg)
    	}

	override func viewDidLoad() {
	…
	botBuilder
            .dialog(path: "/", dialog: BBDialog(waterfall: [{(session : BBSession, next : BBDialog?) -> Void in
                if let name = session.userData["name"] {
                    if let _next = next {
                        _next.next(session, nil)
                    }
                } else {
                    session.beginDialog(path: "/profile")
                }
                },
                {(session : BBSession, next : BBDialog?) -> Void in
                    if let name = session.userData["name"] {
                        //session.send(format: "Hello %s!", args: name as AnyObject)
                        session.send("Hello \(name)!")
                    }
                }]))
            .dialog(path: "/profile", dialog : BBDialog(waterfall: [{(session : BBSession, next : BBDialog?) -> Void in
                
                print("/profile dialog")
                session.promptText("Hi! What is your name?")
                
                },{(session : BBSession, next : BBDialog?) -> Void in
                    
                    session.userData.updateValue(session.result, forKey: "name")
                    session.endDialog()
                    
                }]))
        
        botSession.botBuilder = botBuilder
        botSession.delegate = self
	…
	}//viewDidLoad

	override func viewDidAppear(_ animated: Bool) {
        	botSession.beginConversation()
    	}

}
```
