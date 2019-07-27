//
//  CardDynamicBehavior.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/24.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class CardDynamicBehavior: UIDynamicBehavior {

    lazy var collisionBehavior: UICollisionBehavior = {
        var behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()// This is a lazy var, which requires an init

    lazy var itemBehavior: UIDynamicItemBehavior = {
        var behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()


    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
//        push.angle = (2 * CGFloat.pi).drand
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x <= center.x && y <= center.y:
                push.angle = (CGFloat.pi / 2).drand
            case let (x, y) where x >= center.x && y >= center.y:
                push.angle = CGFloat.pi + (CGFloat.pi / 2).drand
            case let (x, y) where x < center.x && y > center.y:
                push.angle = CGFloat.pi * 1.5 + (CGFloat.pi / 2).drand
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi * 0.5 + (CGFloat.pi / 2).drand
            default:
                break
            }
        }
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).drand
        push.action = {
            [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }

    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }

    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }

    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }

    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
