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
    let regex : NSRegularExpression
    
    convenience init(_ regex : NSRegularExpression, priority:Int){
        self.init(regex, waterfall : [], priority: priority)
    }
    
    init(_ regex : NSRegularExpression, waterfall: [BBNext], priority:Int){
        self.priority = priority
        self.regex = regex
        super.init("/intent", waterfall: waterfall)
    }
    
    override public var description: String{
        var result = ""
        result.append("BBIntentDialog \n")
        result.append("- steps : \(self.waterfall.count)")
        result.append("- priority : \(self.priority)")
        return result
    }
    
}
