//
//  Gif.swift
//  GifMaker
//
//  Created by Abad Vera on 10/18/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding {
    var url: NSURL?
    var caption: String?
    let gifImage: UIImage?
    var videoURL: NSURL?
    var gifData: NSData?
    
    init(url: NSURL, videoURL: NSURL, caption: String?) {
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString!)
        self.gifData = nil
    }
    
    init(name: String) {
        self.gifImage = UIImage.gif(name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as! NSURL?
        self.videoURL = aDecoder.decodeObject(forKey: "videoURL") as! NSURL?
        self.caption = aDecoder.decodeObject(forKey: "caption") as! String?
        self.gifImage = aDecoder.decodeObject(forKey: "gifImage") as! UIImage?
        self.gifData = aDecoder.decodeObject(forKey: "gifData") as! NSData?
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.videoURL, forKey: "videoURL")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.gifImage, forKey: "gifImage")
        aCoder.encode(self.gifData, forKey: "gifData")
    }
}
