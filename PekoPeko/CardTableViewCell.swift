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
                let cache = Shared.imageCache
                if let shopCoverUrl = card.shopCoverUrl {
                    let URL = NSURL(string: shopCoverUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        self.imageViewCover.image = image.cropToBounds(width: image.size.width, height: image.size.width * 1.8 / 3.0)
                    })
                }
                
                if let shopAvatarUrl = card.shopAvatarUrl {
                    let URL = NSURL(string: shopAvatarUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        self.imageViewAvatar.image = image.cropToBounds(width: image.size.height, height: image.size.height)
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
                            if let userNumber = discount.userNumber {
                                if userNumber != 0 {
                                    viewUserNumber.isHidden = false
                                    labelUserNumber.text = "\(userNumber)"
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
    
}
