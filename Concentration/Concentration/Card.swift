//
//  Card.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

struct Card: Hashable
{


    static func == (lhs: Card, rhs: Card) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.identifier)
    }

    var isFaceUp = false
    var isMatched = false
    private var identifier: Int

    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int
    {
        identifierFactory += 1
        return identifierFactory
    }

    init()
    {
        identifier = Card.getUniqueIdentifier()
    }
}
