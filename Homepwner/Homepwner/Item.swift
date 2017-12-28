//
//  Item.swift
//  Homepwner
//
//  Created by iel-mac on 2017/7/3.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class Item:NSObject,NSCoding{
    var name : String
    var valueInDollars : Int
    var serialNumber : String?
    let dateCreated :Date
    
    let itemKey:String
    
    //initializer 
    init(name:String , serialNumber:String?,valueInDollars:Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    //Convenience initializer
    convenience init(random :Bool = false) {
        if random{
            let adjectives = ["fluffy","Rusty","Shiny"]
            let nouns = ["Bear","Spork","Shiny"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective)\(randomNoun)"
            
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber =
                UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name:randomName,serialNumber:randomSerialNumber,valueInDollars:randomValue)
            
        }else{
            self.init(name:"",serialNumber:nil,valueInDollars:0)
            
        }
    }
    
    //实现NSCoding的方法
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey:"name")
        aCoder.encode(dateCreated,forKey:"dateCreate")
        aCoder.encode(serialNumber,forKey:"serialNumber")
        aCoder.encode(itemKey,forKey:"itemKey")
        
        aCoder.encode(valueInDollars,forKey:"valueInDollars")
    }
    
    //实现NSCoding反序列化的方法
    //required修饰符只能修饰init方法
    required init(coder aDecoder:NSCoder){
        name = aDecoder.decodeObject(forKey:"name") as! String
        dateCreated = aDecoder.decodeObject(forKey:"dateCreate") as! Date
        itemKey = aDecoder.decodeObject(forKey:"itemKey") as! String
        serialNumber = aDecoder.decodeObject(forKey:"serialNumber") as! String?
        
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        
        super.init()
    }
    
}
