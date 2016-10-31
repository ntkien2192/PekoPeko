//
//  StoreTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol CardTableViewCellDelegate: class {
    func cellTapped(card: Card?)
}

class CardTableViewCell: UITableViewCell {
    static let identify = "CardTableViewCell"
    
    weak var delegate: CardTableViewCellDelegate?
    
    @IBOutlet weak var imageViewCover: ImageView!
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelUserNumber: Label!
    @IBOutlet weak var imageViewDiscount: ImageView!
    @IBOutlet weak var viewUserNumber: View!
    
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
                
                if let discount = card.discount {
                    if let isVisible = discount.isVisible {
                        if isVisible {
                            imageViewDiscount.isHidden = false
                            if let usesNumber = discount.usesNumber {
                                if usesNumber != 0 {
                                    viewUserNumber.isHidden = false
                                    labelUserNumber.text = "\(usesNumber)"
                                } else {
                                    viewUserNumber.isHidden = true
                                }
                            }
                        } else {
                            viewUserNumber.isHidden = true
                            imageViewDiscount.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        delegate?.cellTapped(card: card)
    }
    
//    @IBAction func buttonShopTapped(_ sender: AnyObject) {
//        delegate?.shopTapped(card: card)
//    }
}
