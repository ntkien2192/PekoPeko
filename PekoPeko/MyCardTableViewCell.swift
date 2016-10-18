//
//  MyCardTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 12/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol MyCardTableViewCellDelegate: class {
    func cellTapped(card: Card?)
    func moreTapped(card: Card?)
//    func shopTapped(card: Card?)
}

class MyCardTableViewCell: UITableViewCell {

    static let identify = "MyCardTableViewCell"
    
    weak var delegate: MyCardTableViewCellDelegate?
    
    @IBOutlet weak var imageViewCover: ImageView!
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewHoneyNumber: UIView!
    @IBOutlet weak var viewRewardUnlocked: UIImageView!
    
    var card: Card? {
        didSet {
            if let card = card {
                
                if let shopCoverUrl = card.shopCoverUrl {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: shopCoverUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewCover.image = image.cropToBounds(width: image.size.width, height: image.size.width * 1.8 / 3.0)
                    })
                }
                
                if let shopAvatarUrl = card.shopAvatarUrl {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: shopAvatarUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewAvatar.image = image.cropToBounds(width: image.size.height, height: image.size.height)
                    })
                }

                if let cardAddress = card.cardAddress {
                    labelAddress.text = cardAddress
                }
                
                if let shopName = card.shopName {
                    labelName.text = shopName
                }
            }
        }
    }
    
//    @IBAction func buttonShopTapped(_ sender: AnyObject) {
//        delegate?.shopTapped(card: card)
//    }
    
    @IBAction func buttonMoreTapped(_ sender: AnyObject) {
        delegate?.moreTapped(card: card)
    }

    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        delegate?.cellTapped(card: card)
    }
    
    @IBAction func buttonShareTapped(_ sender: AnyObject) {
        
    }
}
