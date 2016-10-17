//
//  CardAddressTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 16/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol CardAddressTableViewCellDelegate: class {
    func addressTapped(address: Address?)
}

class CardAddressTableViewCell: UITableViewCell {

    static let identify = "CardAddressTableViewCell"
    
    weak var delegate: CardAddressTableViewCellDelegate?
    
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewThumb: UIImageView!
    
    var address: Address? {
        didSet {
            if let address = address {
                
                if let thumb = address.thumb {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: thumb)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewThumb.image = image
                    })
                }
                if let addressContent = address.addressContent {
                    labelAddress.text = addressContent
                }
            }
        }
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        delegate?.addressTapped(address: address)
    }
}
