//
//  InfoTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 17/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol ShopInfoTableViewCellDelegate: class {
    func followTapped(shop: Shop?, isFollowing: Bool)
}

class ShopInfoTableViewCell: UITableViewCell {

    static let identify = "ShopInfoTableViewCell"
    
    weak var delegate: ShopInfoTableViewCellDelegate?
    
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var buttonFollow: Button!
    @IBOutlet weak var buttonFollowing: UIButton!
    
    var shop: Shop? {
        didSet {
            if let shop = shop {
                if let avatarUrl = shop.avatarUrl {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: avatarUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewAvatar.image = image
                    })
                }
                
                if let name = shop.fullName {
                    labelName.text = name
                }
                
                if let category = shop.categories {
                    labelCategory.text = category
                }
                
                if let followers = shop.followers {
                    var valueText = "\(followers)"
                    if Double(followers) > 1000.0 {
                        let value = floor(Double(followers)/1000.0)
                        valueText = "\(value)K"
                    }
                    
                    let titleParagraphStyle = NSMutableParagraphStyle()
                    titleParagraphStyle.alignment = .center
                    
                    let attributedText = NSMutableAttributedString()
                    let attribute1 = [NSFontAttributeName: UIFont(name: "Bebas", size: 14)!, NSForegroundColorAttributeName: UIColor.darkGray, NSParagraphStyleAttributeName: titleParagraphStyle]
                    let variety1 = NSAttributedString(string: "\(valueText)\n", attributes: attribute1)
                    attributedText.append(variety1)
                    let attribute2 = [NSFontAttributeName: UIFont.getFont(10), NSForegroundColorAttributeName: UIColor.RGB(127, green: 127, blue: 127), NSParagraphStyleAttributeName: titleParagraphStyle]
                    let variety2 = NSAttributedString(string: "Người theo dõi", attributes: attribute2)
                    attributedText.append(variety2)
                    
                    buttonFollowing.setAttributedTitle(attributedText, for: .normal)
                    buttonFollowing.titleLabel?.numberOfLines = 2
                    
                }
                
                if let isFollowing = shop.isFollowing {
                    self.isFollowing = isFollowing
                }
            }
        }
    }
    
    var isFollowing: Bool = false {
        didSet {
            if isFollowing {
                buttonFollow.setTitle("ĐANG THEO DÕI", for: .normal)
            } else {
                buttonFollow.setTitle("THEO DÕI", for: .normal)
            }
        }
    }
    
    @IBAction func buttonFollowTapped(_ sender: AnyObject) {
        delegate?.followTapped(shop: shop, isFollowing: isFollowing)
    }
    
}
