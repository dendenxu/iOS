//
//  ViewController.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/6/30.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var flipCountLabel: UILabel!//The exclaiming mark means that the variable is an optional an is automatically unwrapped whenever used
    var flipCount = 0
    {
        didSet//didSet is like the monitor of a vaiable, whenever something changes, the program does the following stuff
        {
            flipCountLabel.text = "Flip Count: \(flipCount)";
        }
    }

    @IBOutlet var cardButtons: [UIButton]!
    var emojiCollections = ["👻","🎃","👻","🎃"]
    
    @IBAction func touchCard(_ sender: UIButton)
    {
        flipCount+=1;
        if let cardIndex = cardButtons.firstIndex(of: sender)
        {
            print("cardIndex is at \(cardIndex)");
            flipCard(withEmoji:emojiCollections[cardIndex],on:sender);
        }
        else
        {
            print("Button is not in the array");
        }
    }
    
//    @IBAction func touchSecondCard(_ sender: UIButton)
//    {
//        flipCount+=1;
//        flipCard(withEmoji: "🎃", on: sender);
//    }
//These are duplicated codes and are really unwelcomed, should be augmented
    
    func flipCard(withEmoji emoji:String, on button:UIButton)
    {
        print("flipCard(withEmoji: \(emoji))");
        if button.currentTitle == emoji
        {
            button.setTitle("", for: UIControl.State.normal);
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1);
        }
        else
        {
            button.setTitle(emoji, for: UIControl.State.normal);
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
        }
    }
}

