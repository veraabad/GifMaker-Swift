//
//  GifCell.swift
//  GifMaker
//
//  Created by Abad Vera on 10/18/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var gifImageView: UIImageView!
    var prevSelection: Bool!
    var storedGif: Gif!
    
    func configureForGif(gif: Gif) {
        storedGif = gif
        checkImage.isHidden = true
        gifImageView.image = gif.gifImage
        isSelected = false
    }
    
    func selectCell() {
        checkImage.isHidden = !isSelected
        gifImageView.isOpaque = isSelected
    }
}
