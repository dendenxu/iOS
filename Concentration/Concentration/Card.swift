//
//  Card.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

struct Card//every struct gets a free initializer with all its instance variables queried
    //Differences between struct and array:
    //1. structs are value type(making a copy while passing)
    //2. classes are reference type(passing pointers)
{
    var isFacedup = false;
    var isMatched = false;
    var identifier :Int;
    //We are in the model here, not the UI.
    //So we shouldn't have any emoji or what
    
    static var identifierFactory = 0;
    
    static func getUniqueIdentifier() ->Int
    {
        identifierFactory += 1;
        return identifierFactory;
    }
    
//    init(identifier:Int)
//    {
//        self.identifier = identifier;
//        //approximately self == this. This is a way of distinguishing between these two
//    }
    
    init()
    {
        self.identifier = Card.getUniqueIdentifier();
    }
};
