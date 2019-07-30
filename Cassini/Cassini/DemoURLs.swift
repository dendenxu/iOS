//
//  DemoURLs.swift
//  Cassini
//
//  Created by Xuzh on 2019/7/29.
//  Copyright © 2019 XuZh. All rights reserved.
//

import Foundation

struct DemoURLs
{
    static let stanford = Bundle.main.url(forResource: "Oval", withExtension: "jpg")
//    static let stanford = URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Stanford_Oval_September_2013_panorama.jpg")

    static var NASA: [String: URL] {
        let NASAURLStrings = [
            "Cassini": "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
            "Earth": "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
            "Saturn": "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"
//            "Saturn": "https://cdn.images.express.co.uk/img/dynamic/151/590x/NASA-probed-Saturn-with-its-Cassini-spacecraft-1156016.webp?r=1563714231211"
        ]
        var urls = [String: URL]()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }
}


