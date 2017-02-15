//
//  Constant.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 14/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

struct Barnabot {
    
    struct LuisConfig{
        // endPoint with appId  and subscription key
        static let endPoint = "https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/229071cd-12b8-435b-ae7f-24d329ad5c98?subscription-key=0792efcbf6bf43339f992509848055a5"
    }
    
    struct LuisJson {
        
        static let query = "query"
        static let topScoringIntent = "topScoringIntent"
        static let intent = "intent"
        static let score = "score"
        static let endIndex = "endIndex"
        static let entities = "entities"
        static let entity = "entity"
        static let startIndex = "startIndex"
        static let type = "type"
    }
}

