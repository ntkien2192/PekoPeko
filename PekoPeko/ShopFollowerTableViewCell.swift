//
//  ShopFollowerTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 03/12/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class ShopFollowerTableViewCell: UITableViewCell {

    static let identify = "ShopFollowerTableViewCell"
    
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                if let avatarUrl = user.avatarUrl {
                    
                    imageViewAvatar.contentMode = .scaleAspectFill
                    imageViewAvatar.clipsToBounds = false
                    imageViewAvatar.layer.masksToBounds = true
                    
                    let cache = Shared.imageCache
                    let URL = NSURL(string: avatarUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewAvatar.image = image
                    })
                }
                
                labelName.text = user.fullName ?? ""
            }
        }
    }
    
}
