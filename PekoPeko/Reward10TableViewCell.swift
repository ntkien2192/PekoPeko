//
//  Reward10TableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 13/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol Reward10TableViewCellDelegate: class {
    func buttonExchangeTapped(reward: Reward?)
}

class Reward10TableViewCell: UITableViewCell {

    static let identify = "Reward10TableViewCell"
    
    weak var delegate: Reward10TableViewCellDelegate?
    
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var viewHoney1: View!
    @IBOutlet weak var imageViewHoney1: UIImageView!
    @IBOutlet weak var viewHoney2: View!
    @IBOutlet weak var imageViewHoney2: UIImageView!
    @IBOutlet weak var viewHoney3: View!
    @IBOutlet weak var imageViewHoney3: UIImageView!
    @IBOutlet weak var viewHoney4: View!
    @IBOutlet weak var imageViewHoney4: UIImageView!
    @IBOutlet weak var viewHoney5: View!
    @IBOutlet weak var imageViewHoney5: UIImageView!
    
    @IBOutlet weak var viewHoney6: View!
    @IBOutlet weak var imageViewHoney6: UIImageView!
    @IBOutlet weak var viewHoney7: View!
    @IBOutlet weak var imageViewHoney7: UIImageView!
    @IBOutlet weak var viewHoney8: View!
    @IBOutlet weak var imageViewHoney8: UIImageView!
    @IBOutlet weak var viewHoney9: View!
    @IBOutlet weak var imageViewHoney9: UIImageView!
    @IBOutlet weak var viewHoney10: View!
    @IBOutlet weak var imageViewHoney10: UIImageView!
    
    @IBOutlet weak var labelNeedMore: UILabel!
    @IBOutlet weak var labelNeedMoreEnd: UILabel!
    
    @IBOutlet weak var buttonExchange: Button!
    
    var reward: Reward? {
        didSet {
            if let reward = reward {
                let cache = Shared.imageCache
                if let imageUrl = reward.imageUrl {
                    let URL = NSURL(string: imageUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        self.imageViewAvatar.image = image
                    })
                }
                
                if let title = reward.title {
                    labelTitle.text = title
                }
                
                if let desc = reward.desc {
                    labelDescription.text = desc
                }
                
                if let hpRequire = reward.hpRequire, let hpCurrent = reward.hpCurrent {
                    let view = [viewHoney1, viewHoney2, viewHoney3, viewHoney4, viewHoney5,
                                viewHoney6, viewHoney7, viewHoney8, viewHoney9, viewHoney10]
                    let imageView = [imageViewHoney1, imageViewHoney2, imageViewHoney3, imageViewHoney4, imageViewHoney5,
                                     imageViewHoney6, imageViewHoney7, imageViewHoney8, imageViewHoney9, imageViewHoney10]
                    
                    for i in 0..<10 {
                        
                        if i < hpRequire {
                            view[i]?.isHidden = false
                            imageView[i]?.isHidden = false
                        } else {
                            view[i]?.isHidden = true
                            imageView[i]?.isHidden = true
                        }
                        
                        if hpCurrent > i {
                            view[i]?.backgroundColor  = UIColor.RGB(147.0, green: 196.0, blue: 42.0)
                            imageView[i]?.isHidden = false
                        } else {
                            view[i]?.backgroundColor  = UIColor.RGB(250, green: 250, blue: 250)
                            imageView[i]?.isHidden = true
                        }
                    }
                    
                    
                    if hpCurrent >= hpRequire {
                        isCanExchange = true
                        buttonExchange.setBackgroundImage(UIImage(named: "ButtonExchangeON"), for: .normal)
                        labelNeedMore.text = "Đã đủ"
                        labelNeedMore.textColor = UIColor.colorOrange
                        labelNeedMoreEnd.textColor = UIColor.colorOrange
                    } else {
                        isCanExchange = false
                        buttonExchange.setBackgroundImage(UIImage(named: "ButtonExchangeOFF"), for: .normal)
                        labelNeedMore.text = "Cần thêm \(hpRequire - hpCurrent)"
                        labelNeedMore.textColor = UIColor.RGB(51, green: 51, blue: 51)
                        labelNeedMoreEnd.textColor = UIColor.RGB(51, green: 51, blue: 51)
                    }
                }
            }
        }
    }
    
    var isCanExchange: Bool = false
    
    @IBAction func buttonExchangeTapped(_ sender: AnyObject) {
        delegate?.buttonExchangeTapped(reward: reward)
    }
}
