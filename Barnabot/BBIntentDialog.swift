//
//  BBIntentDialog.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 10/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

class BBIntentDialog : BBDialog {
    
    var priority:Int
    // Pour pouvoir faire des comparaisons entre plusieurs instances de BBIntentDialog
    let regex : NSRegularExpression
    
    convenience init(_ regex : NSRegularExpression, priority:Int){
        self.init(regex, waterfall : [], priority: priority)
    }
    
    convenience init(_ regex : NSRegularExpression, redir : String, priority:Int){
        let waterfall : [BBNext] = [{(session : BBSession) -> Void in
            session.beginDialog(path: redir)
        }]
        self.init(regex, waterfall : waterfall, priority: priority)
    }
    
    convenience init(_ regex : NSRegularExpression, action: @escaping BBNext, priority:Int){
        var waterfall : [BBNext] = [BBNext]()
        waterfall.append(action)
        self.init(regex, waterfall : waterfall, priority: priority)
    }
    
    init(_ regex : NSRegularExpression, waterfall: [BBNext], priority:Int){
        self.priority = priority
        self.regex = regex
        super.init(regex.pattern, waterfall: waterfall)
    }
    
    override public var description: String{
        var result = ""
        result.append("BBIntentDialog \n")
        result.append("- steps : \(self.waterfall.count)")
        result.append("- priority : \(self.priority)")
        return result
    }
    
    override func copy() -> BBDialog {
        return BBIntentDialog(regex, waterfall : waterfall, priority: 0)
    }
}
