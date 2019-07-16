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
    
    init(numberOfPairsOfCards:Int)
    {
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card();
            cards += [card,card];
        }
    }
    
    func chooseCard(at index:Int)
    {
        if cards[index].isFacedUp
        {
            cards[index].isFacedUp = false;
        }
        else
        {
            cards[index].isFacedUp = true;
        }
    }
};
