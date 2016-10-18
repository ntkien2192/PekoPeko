//
//  ShopMenuTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class ShopMenuTableViewCell: UITableViewCell {
    static let identify = "ShopMenuTableViewCell"
    
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    var menuCellItem: MenuCellItem? {
        didSet {
            if let menuCellItem = menuCellItem {
                if let menuItems = menuCellItem.menuItems, let item = menuItems.first {
                    if let imageUrl = item.imageUrl {
                        let cache = Shared.imageCache
                        let URL = NSURL(string: imageUrl)!
                        let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                        weak var _self = self
                        _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                            _self?.imageViewAvatar.image = image.cropToBounds(width: 256.0, height: 256.0)
                        })
                    }
                
                    if let name = item.name {
                        labelName.text = name
                    }
                    
                    if let price = item.price {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .currency
                        formatter.locale = Locale(identifier: "es_VN")
                        formatter.currencySymbol = "VND"
                        labelPrice.text = "\(NSString(format: "%@", formatter.string(from: NSNumber(value: price))!))"
                    }
                }
            }
        }
    }
}
