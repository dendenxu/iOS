```swift
//
//  ViewController.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/6/30.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController//This shouldn't be changed any time soon
{
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2);//var game: Concentration = Concentration();
    
    var flipCount = 0
    {
        didSet//didSet is like the monitor of a vaiable, whenever something changes, the program does the following stuff
        {
            flipCountLabel.text = "Flip Count: \(flipCount)";
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!//The exclaiming mark means that the variable is an optional an is automatically unwrapped whenever used

    @IBOutlet var cardButtons: [UIButton]!
//    var emojiCollections = ["👻","🎃","👻","🎃"]//omit the type specification because that is not implicit at all
    
    @IBAction func touchCard(_ sender: UIButton)// the _ is for the caller to use
    {
        flipCount+=1;
        if let cardIndex = cardButtons.firstIndex(of: sender)//We do that because we want swift to look like English. The if let structure tests whether the optional variable is a nil. If it is, unwarps it.
        {
//            print("cardIndex is at \(cardIndex)");
//            flipCard(withEmoji:emojiCollections[cardIndex],on:sender);
            game.chooseCard(at: cardIndex);
            updateViewFromModel();
        }
        else
        {
            print("Button is not in the array");
        }
    }
    
    func updateViewFromModel()
    {
        for index in cardButtons.indices
        {
            let button = cardButtons[index];
            let card = game.cards[index];
            if card.isFacedUp
            {
                button.setTitle(emoji(for: card), for: UIControl.State.normal);
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
            }
            else
            {
                button.setTitle("", for: UIControl.State.normal);
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1) ;
            }
        }
    }

    var emojiChoices = ["👻","🎃","🐒","🦕","🦀","🐺","🦋"]//omit the type specification because that is not implicit at all
    
//    var emoji = Dictionary<Int, String>();
    var emoji = [Int:String]();
    
    func emoji(for card:Card) -> String
    {
        // In swift, if we have nested "if"s, we can put them in the same line and seperate them with a comma
        if emoji[card.identifier]==nil, emojiChoices.count != 0
        {
            // arc4randowm_uniform generates random numbers
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)));
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex);
        }
        
//        if emoji[card.identifier] != nil
//        {
//            return emoji[card.identifier]!;
//        }
//        else
//        {
//            return "?";
//        }
        //exactly the same as
        return emoji[card.identifier] ?? "?";
    }
//    @IBAction func touchSecondCard(_ sender: UIButton)
//    {
//        flipCount+=1;
//        flipCard(withEmoji: "🎃", on: sender);
//    }
//These are duplicated codes and are really unwelcomed, should be augmented
    
//    func flipCard(withEmoji emoji:String, on button:UIButton)//We do that because we want swift to look like English
//    {
//        print("flipCard(withEmoji: \(emoji))");
//        if button.currentTitle == emoji
//        {
//            button.setTitle("", for: UIControl.State.normal);
//            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1);
//        }
//        else
//        {
//            button.setTitle(emoji, for: UIControl.State.normal);
//            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
//        }
//    }
}


```

```swift
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
        if cards[index].isFacedUp
        {
            cards[index].isFacedUp = false;
        }
        else
        {
            cards[index].isFacedUp = true;
        }
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

```

```swift
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
    var isFacedUp = false;
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

```

