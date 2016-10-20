//
//  ShopMenu2TableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class ShopMenu2TableViewCell: UITableViewCell {
    static let identify = "ShopMenu2TableViewCell"
    
    @IBOutlet weak var imageViewAvatar1: ImageView!
    @IBOutlet weak var imageViewAvatar2: ImageView!
    
    
    @IBOutlet weak var labelName1: UILabel!
    @IBOutlet weak var labelName2: UILabel!
    
    @IBOutlet weak var labelPrice1: UILabel!
    @IBOutlet weak var labelPrice2: UILabel!
    
    var menuCellItem: MenuCellItem? {
        didSet {
            if let menuCellItem = menuCellItem {
                if menuCellItem.count() != 1 {
                    if let menuItems = menuCellItem.menuItems {
                        imageViewAvatar2.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
                        if let item = menuItems.first {
                            if let imageUrl = item.imageUrl {
                                let cache = Shared.imageCache
                                let URL = NSURL(string: imageUrl)!
                                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                                weak var _self = self
                                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                    _self?.imageViewAvatar1.image = image.cropToBounds(width: 256.0, height: 256.0)
                                })
                            }
                            
                            if let name = item.name {
                                labelName1.text = name
                            }
                            
                            if let price = item.price {
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .currency
                                formatter.locale = Locale(identifier: "es_VN")
                                formatter.currencySymbol = "VND"
                                labelPrice1.text = "\(NSString(format: "%@", formatter.string(from: NSNumber(value: price))!))"
                            }
                        }
                        
                        if let item = menuItems.last {
                            imageViewAvatar2.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
                            if let imageUrl = item.imageUrl {
                                let cache = Shared.imageCache
                                let URL = NSURL(string: imageUrl)!
                                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                                weak var _self = self
                                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                    _self?.imageViewAvatar2.image = image.cropToBounds(width: 256.0, height: 256.0)
                                })
                            }
                            
                            if let name = item.name {
                                labelName2.text = name
                            }
                            
                            if let price = item.price {
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .currency
                                formatter.locale = Locale(identifier: "es_VN")
                                formatter.currencySymbol = "VND"
                                labelPrice2.text = "\(NSString(format: "%@", formatter.string(from: NSNumber(value: price))!))"
                            }
                        }
                    }
                } else {
                    if let menuItems = menuCellItem.menuItems {
                        imageViewAvatar2.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
                        if let item = menuItems.first {
                            if let imageUrl = item.imageUrl {
                                let cache = Shared.imageCache
                                let URL = NSURL(string: imageUrl)!
                                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                                weak var _self = self
                                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                    _self?.imageViewAvatar1.image = image.cropToBounds(width: 256.0, height: 256.0)
                                })
                            }
                            
                            if let name = item.name {
                                labelName1.text = name
                            }
                            
                            if let price = item.price {
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .currency
                                formatter.locale = Locale(identifier: "es_VN")
                                formatter.currencySymbol = "VND"
                                labelPrice1.text = "\(NSString(format: "%@", formatter.string(from: NSNumber(value: price))!))"
                            }
                        }
                    }
                    imageViewAvatar2.backgroundColor = UIColor.white
                    imageViewAvatar2.image = UIImage()
                    labelName2.text = ""
                    labelPrice2.text = ""
                }
            }
        }
    }
}
