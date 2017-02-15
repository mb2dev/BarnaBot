//
//  Entities.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 14/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

class Entities : NSObject{
    
    var entity : String
    var type : String
    var startIndex : Double
    var endIndex : Double
    var score : Double
    
    init(entity:String, type:String, startIndex: Double, endIndex: Double,score:Double) {
        self.entity = entity
        self.type = type
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.score = score
    }
    
    override var description: String{
        var result = "Entities : \n"
        result.append("\t entity :" + self.entity)
        result.append("\n\t type : " + self.type)
        result.append("\n\t startIndex : " + String(self.startIndex))
        result.append("\n\t endIndex : " + String(self.endIndex))
        result.append("\n\t score : " + String(self.score))
        return result
        
    }
    
}
