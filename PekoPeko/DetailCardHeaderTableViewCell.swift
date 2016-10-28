//
//  DetailCardHeaderTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 12/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol DetailCardHeaderTableViewCellDelegate: class {
    func shopTapped(card: Card?)
}

class DetailCardHeaderTableViewCell: UITableViewCell {

    static let identify = "DetailCardHeaderTableViewCell"
    
    weak var delegate: DetailCardHeaderTableViewCellDelegate?
    
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewCover: UIImageView!
    
    var card: Card? {
        didSet {
            if let card = card {
                
                if let shopCoverUrl = card.shopCoverUrl {
                    imageViewCover.contentMode = .scaleAspectFill
                    imageViewCover.clipsToBounds = false
                    imageViewCover.layer.masksToBounds = true
                    
                    let cache = Shared.imageCache
                    let URL = NSURL(string: shopCoverUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewCover.image = image
                    })
                }
                
                if let shopAvatarUrl = card.shopAvatarUrl {
                    imageViewAvatar.contentMode = .scaleAspectFill
                    imageViewAvatar.clipsToBounds = false
                    imageViewAvatar.layer.masksToBounds = true
                    
                    let cache = Shared.imageCache
                    let URL = NSURL(string: shopAvatarUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewAvatar.image = image.resizeImage(targetSize: CGSize(width: 80, height: 80))
                    })
                }
                
                if let shopAddress = card.shopAddress {
                    labelAddress.text = shopAddress
                }
                
                if let shopName = card.shopName {
                    labelName.text = shopName
                }
            }
        }
    }
    
    @IBAction func buttonRestaurantTapped(_ sender: AnyObject) {
        delegate?.shopTapped(card: card)
    }
    
}
