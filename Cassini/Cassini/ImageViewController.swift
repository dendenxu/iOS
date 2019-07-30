//
//  ImageViewController.swift
//  Cassini
//
//  Created by Xuzh on 2019/7/29.
//  Copyright © 2019 XuZh. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.25
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.bounds.size
            spinner?.stopAnimating()
        }
    }
    
    var imageURL: URL? = DemoURLs.stanford {
        didSet {
            if view.window != nil {
                fetchImage()
            }
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func fetchImage() {
        spinner.startAnimating()
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                // TODO: terminate this when the image is no longer needed
                // When user makes another request, I want this fetching terminated. How?
                let urlContent = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if let imageData = urlContent, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
}

