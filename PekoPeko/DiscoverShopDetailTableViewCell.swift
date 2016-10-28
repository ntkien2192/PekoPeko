//
//  DiscoverShopDetailTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol DiscoverShopDetailTableViewCellDelegate: class {
    func telephoneTapped(shop: Shop?, telephone: String)
    func shopTapped(shop: Shop?)
}

class DiscoverShopDetailTableViewCell: UITableViewCell {

    static let identify = "DiscoverShopDetailTableViewCell"
    
    weak var delegate: DiscoverShopDetailTableViewCellDelegate?
    
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopAddress: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelWorkTime: UILabel!
    @IBOutlet weak var buttonPhone: Button!
    @IBOutlet weak var imageViewAvatar: ImageView!
    
    var discover: Discover? {
        didSet {
            if let discover = discover, let shop = discover.shop {
                
                if let shopAvatarUrl = shop.avatarUrl {
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
                
                if let name = shop.fullName {
                    labelShopName.text = name
                }
                
                if let address = shop.address, let addressContent = address.addressContent {
                    labelShopAddress.text = addressContent
                }
                
                if let avgPrice = shop.avgPrice {
                    labelPrice.text = avgPrice
                }
                
                if let workTime = shop.workTime {
                    if let openTime = workTime.openTime, let closeTime = workTime.closeTime {
                        labelWorkTime.text = "\(openTime) - \(closeTime)"
                    }
                }
                
                if let telephone = shop.telephone {
                    if !telephone.isEmpty {
                        buttonPhone.isHidden = false
                        self.telephone = telephone
                    }
                }
            }
        }
    }
    
    var telephone: String = "" {
        didSet {
            buttonPhone.setTitle(telephone, for: .normal)
        }
    }
    
    @IBAction func buttonShopTapped(_ sender: AnyObject) {
        if let discover = discover, let shop = discover.shop {
            delegate?.shopTapped(shop: shop)
        }

    }
    
    @IBAction func buttonPhoneTapped(_ sender: AnyObject) {
        if let discover = discover {
            delegate?.telephoneTapped(shop: discover.shop, telephone: telephone)
        }
    }
}
