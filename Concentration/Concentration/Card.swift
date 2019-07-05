//
//  Card.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

struct Card//every struct gets a free initializer with all its instance variables queried
{
    var isFacedup = false;
    var isMatched = false;
    var identifier :Int;
    
    init(identifier:Int)
    {
        self.identifier = identifier;
        //approximately self == this
    }
    
};
