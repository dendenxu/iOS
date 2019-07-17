//
//  Concentrarion.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]();
    var indexOfOneAndOnlyFaceUpCard: Int?;
    init(numberOfPairsOfCards: Int)
    {
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card();
            cards += [card, card];
        }
        cards = shuffle(theArray: cards);
    }

    func shuffle(theArray: [Card]) -> [Card]
    {
        var list = theArray;
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count - index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex);
            }
        }
        return list;
    }

    func chooseCard(at index: Int)
    {
        if !cards[index].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
                if cards[matchIndex].identifier == cards[index].identifier
                {
                    cards[matchIndex].isMatched = true;
                    cards[index].isMatched = true;
                }
                cards[index].isFaceUp = true;
                indexOfOneAndOnlyFaceUpCard = nil;
            }
            else
            {
                for flipCardIndex in cards.indices
                {
                    cards[flipCardIndex].isFaceUp = false;
                }
                cards[index].isFaceUp = true;
                indexOfOneAndOnlyFaceUpCard = index;
            }
        }

    }
};
