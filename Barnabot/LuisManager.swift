//
//  parsingJsonLuis.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 14/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

public class LuisManager{
    
     public static let sharedIntances = LuisManager()
    
    func RequestLuis(msg:String, completion: @escaping (LuisModel)->Void){
        var dictionary:[String: AnyObject]? = nil
        let escapedString = msg.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = URL(string: Barnabot.LuisConfig.endPoint + "&q=" + escapedString!)
        _ = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            dictionary = json as? [String : AnyObject]
            //print(json)
            print(self.readJsonLuis(JsonObject: dictionary!).description)
            completion(self.readJsonLuis(JsonObject: dictionary!))
           
            }.resume()
    }
    
    
    
    func readJsonLuis(JsonObject: [String: AnyObject]) -> LuisModel{
        let query = JsonObject[Barnabot.LuisJson.query]  as? String
        let topScorinIntentObject = JsonObject[Barnabot.LuisJson.topScoringIntent]  as?  AnyObject
        let intent = topScorinIntentObject?[Barnabot.LuisJson.intent] as? String
        let score = topScorinIntentObject?[Barnabot.LuisJson.score] as? Double
        
        let topScoring = TopScoringIntent(intent : intent!, score : score!)
        
        let entities = JsonObject[Barnabot.LuisJson.entities] as? [AnyObject]
        
        var entitiesList: [Entities] = []

        for entity in entities! {
            let entity2 = entity[Barnabot.LuisJson.entity] as? String
            let endIndex = entity[Barnabot.LuisJson.endIndex] as? Double
            let startIndex = entity[Barnabot.LuisJson.startIndex] as? Double
            let score = entity[Barnabot.LuisJson.score] as? Double
            let type = entity[Barnabot.LuisJson.type] as? String
            let newEntity = Entities(entity:entity2!, type:type!, startIndex: startIndex!, endIndex: endIndex!,score:score!)
            entitiesList.append(newEntity)
        }
        return LuisModel(query:query!, topScoring: topScoring, entities: entitiesList)
        
    }
}
