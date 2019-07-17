//
//  Card.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false;
    var isMatched = false;
    var identifier: Int;

    static var identifierFactory = 0;

    static func getUniqueIdentifier() -> Int
    {
        identifierFactory += 1;
        return identifierFactory;
    }

    init()
    {
        self.identifier = Card.getUniqueIdentifier();
    }
};
