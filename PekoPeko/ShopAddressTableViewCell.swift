//
//  ShopAddressTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 17/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol ShopAddressTableViewCellDelegate: class {
    func telephoneTapped(shop: Shop?, telephone: String)
    func showMoreAddressTapped(shop: Shop?)
    func addressTapped(address: Address?)
}

class ShopAddressTableViewCell: UITableViewCell {

    static let identify = "ShopAddressTableViewCell"
    
    weak var delegate: ShopAddressTableViewCellDelegate?
    
    @IBOutlet weak var buttonMoreAddress: UIButton!
    @IBOutlet weak var buttonTelephone: Button!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelOpenTime: UILabel!
    @IBOutlet weak var imageViewAddress: UIImageView!
    
    var shop: Shop? {
        didSet {
            if let shop = shop {
                if let addresses = shop.addresses {
                    if addresses.count > 0 {
                        if addresses.count == 1 {
                            buttonMoreAddress.isHidden = true
                        } else if addresses.count > 1 {
                            buttonMoreAddress.isHidden = false
                        }
                        
                        if let address = addresses.first {
                            self.address = address
                        }
                    }
                }
                
                if let avgPrice = shop.avgPrice {
                    labelPrice.text = avgPrice
                }
                
                if let workTime = shop.workTime {
                    if let openTime = workTime.openTime, let closeTime = workTime.closeTime {
                        labelOpenTime.text = "\(openTime) - \(closeTime)"
                    }
                }
                
                if let telephone = shop.telephone {
                    if !telephone.isEmpty {
                        buttonTelephone.isHidden = false
                        self.telePhone = telephone
                    }
                }
            }
        }
    }
    
    var address: Address? {
        didSet {
            if let address = address {
                if let addressContent = address.addressContent {
                    labelAddress.text = addressContent
                }
                
                if let thumb = address.thumb {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: thumb)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewAddress.image = image
                    })
                }
            }
        }
    }
    
    var telePhone: String = "" {
        didSet {
            buttonTelephone.setTitle(telePhone, for: .normal)
        }
    }
    
    @IBAction func buttonTelephoneTapped(_ sender: AnyObject) {
        delegate?.telephoneTapped(shop: shop, telephone: telePhone)
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        delegate?.addressTapped(address: address)
    }
    
    @IBAction func buttonShowMoreAddressTapped(_ sender: AnyObject) {
        delegate?.showMoreAddressTapped(shop: shop)
    }
    
}
