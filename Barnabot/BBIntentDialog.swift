//
//  BBIntentDialog.swift
//  BarnaBotSample
//
//  Created by Mickael Bordage on 10/02/2017.
//  Copyright © 2017 Mickael Bordage. All rights reserved.
//

import Foundation

 class BBIntentDialog : BBDialog {
    
    public var priority:Int
    
    init(priority:Int){
        self.priority = priority
        super.init(waterfall: [])
    }
    
    init(waterfall: [BBNext], priority:Int){
        self.priority = priority
        super.init(waterfall: waterfall)
    }
    
    override public var description: String{
        var result = ""
        result.append("BBIntentDialog \n")
        result.append("- steps : \(self.waterfall.count)")
        result.append("- priority : \(self.priority)")
        return result
    }
    
}
