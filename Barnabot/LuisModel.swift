//
//  LuisModel.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 14/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

class LuisModel : NSObject{
    
    var query:String
    var topScoring:TopScoringIntent
    var entities: [Entities]
    
    init(query:String, topScoring: TopScoringIntent, entities: [Entities]) {
        self.query = query
        self.topScoring = topScoring
        self.entities = entities
    }
    
    override var description: String{
        var result = "LuisModel : \n"
        result.append("\t" + self.topScoring.description)
        for entity in self.entities {
            result.append("\n\t" + entity.description)
        }
        return result
    }
}
