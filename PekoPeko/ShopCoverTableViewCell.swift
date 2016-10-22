//
//  ShopCoverTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class ShopCoverTableViewCell: UITableViewCell {
    
    static let identify = "ShopCoverTableViewCell"
    
    @IBOutlet weak var imageViewCover: UIImageView!
    
    var shop: Shop? {
        didSet {
            if let shop = shop, let coverUrl = shop.coverUrl {
                let cache = Shared.imageCache
                let URL = NSURL(string: coverUrl)!
                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                weak var _self = self
                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                    _self?.imageViewCover.image = image.cropToBounds(width: image.size.width, height: image.size.width * 200.0 / 320.0)
                })
            }
        }
    }
}
