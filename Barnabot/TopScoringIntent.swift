//
//  TopScoringIntent.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 14/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

class TopScoringIntent: NSObject{
    var intent:String
    var score:Double
    
    init(intent:String, score:Double) {
       self.intent = intent
       self.score = score
    }
    
    override var description: String{
       var result = ""
        result.append("TopScoringIntent object : \n")
        result.append("\t intent" + self.intent)
        result.append("\n\t" + String(self.score))
        return result
    }
    
    
    
    
}
