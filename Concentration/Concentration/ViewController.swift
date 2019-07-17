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

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2);

    @IBOutlet weak var flipCountLabel: UILabel!
    var flipCount = 0
    {
        didSet
        {
            flipCountLabel.text = "Flip Count: \(flipCount)";
        }
    }

    @IBOutlet var cardButtons: [UIButton]!

    @IBAction func touchCard(_ sender: UIButton)
    {
        flipCount += 1;
        if let cardIndex = cardButtons.firstIndex(of: sender)
        {
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
            if card.isFaceUp
            {
                button.setTitle(emoji(for: card), for: UIControl.State.normal);
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
            }
            else
            {
                button.setTitle("", for: UIControl.State.normal);
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0): #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1) ;
            }
        }
    }

    var emojiChoices = ["👻", "🎃", "🐒", "🦕", "🦀", "🐺", "🦋", "🐦", "🐙", "🦐"];
    var emoji = [Int: String]();
    func emoji(for card: Card) -> String
    {
        if emoji[card.identifier] == nil, emojiChoices.count != 0
        {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)));
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex);
        }

        return emoji[card.identifier] ?? "?";
    }

}

