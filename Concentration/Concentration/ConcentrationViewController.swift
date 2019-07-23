//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/6/30.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController
{



    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int
    {
        return (cardButtons.count + 1) / 2
    }

    @IBOutlet private weak var flipCountLabel: UILabel!
    {
        didSet
        {
            updateFlipCountLabel()
        }
    }

    private var flipCount = 0
    {
        didSet
        {
            updateFlipCountLabel()
        }
    }

    private func updateFlipCountLabel()
    {
        let attributes: [NSAttributedString.Key: Any] =
            [
                    .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                    .strokeWidth: 5.0,
            ]
        let attribtext = NSAttributedString(string: "Flip Count: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attribtext
    }

    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction private func touchCard(_ sender: UIButton)
    {
        flipCount += 1
        if let cardIndex = cardButtons.firstIndex(of: sender)
        {
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
        else
        {
            print("Button is not in the array")
        }
    }

    private func updateViewFromModel()
    {
       if cardButtons != nil
       {
            for index in cardButtons.indices
            {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp
                {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                }
                else
                {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0): #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                }
            }
        }
    }

    var theme: String?
    {
        didSet
        {
            emojiChoices = theme ?? ""
            emoji = [:]//inferring the type of a dict
            updateViewFromModel()
        }
    }
//    private var emojiChoices = ["👻", "🎃", "🐒", "🦕", "🦀", "🐺", "🦋", "🐦", "🐙", "🦐"];
    private var emojiChoices = "👻🎃🐒🦕🦀🐺🦋🐦🐙🦐"
    private var emoji = [Card: String]()
    private func emoji(for card: Card) -> String
    {
        if emoji[card] == nil, emojiChoices.count != 0
        {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }

        return emoji[card] ?? "?"
    }
}

extension Int
{
    var arc4random: Int
    {
        if self > 0
        {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0
        {
            return -Int(arc4random_uniform(UInt32(-self)))
        }
        else
        {
            return 0
        }
    }
}
