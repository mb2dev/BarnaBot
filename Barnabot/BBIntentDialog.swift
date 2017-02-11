//
//  BBIntentDialog.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 10/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

 public class BBIntentDialog:NSObject {
    
    public var idDialog:String
    public var priority:Int
    
    init(idDialog:String, priority:Int){
       self.idDialog = idDialog
        self.priority = priority
    }
    
    
    override public var description: String{
        var result = ""
        result.append("BBIntentDialog \n")
        result.append("-idDialog :" + self.idDialog)
        result.append("- priority :" + String(self.priority))
        return result
    }
    
}
