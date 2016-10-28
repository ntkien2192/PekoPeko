//
//  ImageMoreCollectionViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class ImageMoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    static let identify = "ImageMoreCollectionViewCell"
    
    var image: String? {
        didSet {
            if let image = image {
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = false
                imageView.layer.masksToBounds = true
                
                if !image.isEmpty {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: image)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        if let _self = _self {
                            _self.imageView.image = image
                        }
                    })
                } else {
                    imageView.image = UIImage(named: "DefaultCellImage")
                }
            }
        }
    }
}
