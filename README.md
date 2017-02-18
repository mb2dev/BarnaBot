# BarnaBot

A local bot written in Swift for awesome user interactions!  
Inspired by the [Microsoft Bot Framework](https://dev.botframework.com)

### Simple declaration
```swift
    var botBuilder = BBBuilder("Barnabot")
    var botSession = BBSession.sharedInstance
    botSession.delegate = self

    botBuilder
        .dialog(path: "/", [{(session : BBSession) -> Void in
            if let name = session.getUserData("name") {
                session.next()
            } else {
                session.beginDialog("/profile")
            }
        },
        {(session : BBSession) -> Void in
            if let name = session.getUserData("name") {
                session.send("Hello \(name)!")
            }
            session.endDialog()
        }])
        .dialog(path "/profile", [{(session : BBSession) -> Void in
            session.promptText("What's your name?")
        },{(session : BBSession) -> Void in
            session.saveUserData(value: session.result, forKey: "name").endDialog()
        }])

    botSession.beginConversation()
```

### Intents support
```swift
  botBuilder
    .matches("^help$", priority: 0, redir: "/help")
    .matches("^bonjour", priority: 0, [{(session : BBSession) -> Void in
      session.send("I'm glad to see u back")
      session.promptText("How are you today?")
    },{(session : BBSession) -> Void in
      session.saveUserData(value: session.result, forKey: "mood").endDialog()
    }])
```
