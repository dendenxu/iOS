//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Xuzh on 2019/7/31.
//  Copyright © 2019 XuZh. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate {


    @IBOutlet weak var emojiArtView: EmojiArtView!

    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    var imageFetcher: ImageFetcher!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        spinner.startAnimating()
        imageFetcher = ImageFetcher { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtView.backgroundImage = image
                self.spinner.stopAnimating()
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        }
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
    }

}
