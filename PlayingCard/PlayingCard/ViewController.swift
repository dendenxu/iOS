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

    @IBOutlet private var cardViews: [PlayingCardView]!

    var cards = [PlayingCard]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...(cardViews.count + 1) / 2 {
            if let card = deck.draw() {
                cards += [card, card]
            }
        }

        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }

    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {
            $0.isFaceUp && !$0.isHidden
        }
    }

    private var faceUpCardViewsMatched: Bool {
        return faceUpCardViews.count == 2 &&
            !faceUpCardViews[0].isHidden && !faceUpCardViews[1].isHidden &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }

    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.curveEaseInOut, .transitionFlipFromBottom],
                    animations: { chosenCardView.isFaceUp = !chosenCardView.isFaceUp },
                    completion: {
                        finished in
                        if self.faceUpCardViewsMatched {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    self.faceUpCardViews.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
//                                        $0.frame = $0.frame.zoom(by: 3.0)
                                    }
                                },
//                                completion: {
//                                    position in
//                                    self.faceUpCardViews.forEach {
//                                        $0.transform = CGAffineTransform.identity
//                                        $0.frame = $0.frame.zoom(by: 3.0)
//                                    }
//                                }
                                completion: {
                                    position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            self.faceUpCardViews.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: {
                                            position in
                                            self.faceUpCardViews.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                }
                            )
                        } else if self.faceUpCardViews.count == 2 {
                            self.faceUpCardViews.forEach {
                                chosenCardView in
                                UIView.transition(
                                    with: chosenCardView,
                                    duration: 0.6,
                                    options: [.curveEaseInOut, .transitionFlipFromBottom],
                                    animations: { chosenCardView.isFaceUp = false }
                                )
                            }
                        }
                    }
                )
            }
        default: break
        }
    }

//    @IBOutlet weak var PlayingCardView: PlayingCardView!
//    {
//        didSet
//        {
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
//            swipe.direction = [.left, .right]
//            PlayingCardView.addGestureRecognizer(swipe)
//            let pinch = UIPinchGestureRecognizer(target: PlayingCardView, action: #selector(PlayingCardView.setPlayingCardScale(byPinchGestureRecognizer:)))
//            PlayingCardView.addGestureRecognizer(pinch)
//        }
//    }

//    @IBAction func flipCard(_ sender: UITapGestureRecognizer)
//    {
//        switch sender.state
//        {
//        case .ended: PlayingCardView.isFaceUp = !PlayingCardView.isFaceUp
//        default: break
//        }

//    }
//    @objc func nextCard()
//    {
//        if let card = deck.draw()
//        {
//            PlayingCardView.rank = card.rank.order
//            PlayingCardView.suit = card.suit.rawValue
//        }
//    }



}

