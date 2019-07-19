//
//  ViewController.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/18.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    @IBOutlet weak var PlayingCardView: PlayingCardView!
    {
        didSet
        {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left,.right]
            PlayingCardView.addGestureRecognizer(swipe)
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer)
    {
        PlayingCardView.isFaceUp = !PlayingCardView.isFaceUp
    }
    @objc func nextCard()
    {
        if let card = deck.draw()
        {
            PlayingCardView.rank = card.rank.order
            PlayingCardView.suit = card.suit.rawValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

