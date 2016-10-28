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
    
    @IBOutlet weak var labelHpCurrent: UILabel!
    @IBOutlet weak var viewHoneyNumber: UIView!
    @IBOutlet weak var labelHpMore: UILabel!
    
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

                if let cardAddress = card.cardAddress {
                    labelAddress.text = cardAddress
                }
                
                if let shopName = card.shopName {
                    labelName.text = shopName
                }
                
                if let hpCurrent = card.hpCurrent, let hpRequire = card.hpRequire{
                    labelHpCurrent.text = "\(hpCurrent)"
                    labelHpMore.text = "\(hpRequire - hpCurrent)"
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
}
