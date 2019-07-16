//
//  Concentrarion.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

class Concentration//every class gets a free initalizer with no parameters as long as all its variables are initialized
{
    var cards = [Card]();//[Card] is an array, array has multiple initializers, one of which is this empty init. This is the same as Array<Card>()
    
    func chooseCard(at index:Int)
    {
        
    }
    //init is a function that has the same inside and outside parameter
    init(numberOfPairsOfCards:Int)
    {
        //Using for loop with a sequenced stuff
        //Here we use countable range
        //for identifier in 0..<numberOfPairsOfCards
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card();//We let card decide its unique identifier
            //cards.append(card);
            //cards.append(card);
            //Using method:append to add something in an array
            cards += [card,card];//When putting something inside an array, swift makes a copy of it
        }
        
        //TODO:shuffle the cards
    }
};
