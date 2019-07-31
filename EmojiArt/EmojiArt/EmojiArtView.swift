//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Xuzh on 2019/7/31.
//  Copyright © 2019 XuZh. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }


}
