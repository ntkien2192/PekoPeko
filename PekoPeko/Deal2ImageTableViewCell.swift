//
//  Deal2ImageTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol Deal2ImageTableViewCellDelegate: class {
    func shareDiscoverTapped(discover: Discover?)
    func saveDiscoverTapped(discover: Discover?)
    func discovertapped(discover: Discover?)
    func likeDiscoverTapped(discover: Discover?)
}

class Deal2ImageTableViewCell: UITableViewCell {
    
    static let identify = "Deal3ImageTableViewCell"
    
    weak var delegate: Deal2ImageTableViewCellDelegate?
    
    @IBOutlet weak var constraintLineBottonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewShopAvatar: ImageView!
    @IBOutlet weak var imageView1: ImageView!
    @IBOutlet weak var imageView2: ImageView!
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopAddress: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelUserSaved: Label!
    @IBOutlet weak var buttonSave: UIButton!
    
    @IBOutlet weak var labelDate1: Label!
    @IBOutlet weak var labelDate2: Label!
    @IBOutlet weak var labelHour1: Label!
    @IBOutlet weak var labelHour2: Label!
    @IBOutlet weak var labelMinute1: Label!
    @IBOutlet weak var laberMinute2: Label!
    
    @IBOutlet weak var imageViewLike: ImageView!
    @IBOutlet weak var labelLike: UILabel!
    
    var isLast: Bool = false {
        didSet {
            if isLast {
                constraintLineBottonHeight.constant = 0.0
            } else {
                constraintLineBottonHeight.constant = 20.0
            }
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                imageViewLike.image = UIImage(named: "IconLiked")
            } else {
                imageViewLike.image = UIImage(named: "IconLike")
                
            }
            imageViewLike.animation = "zoomIn"
            imageViewLike.animate()
        }
    }
    
    var isSaved: Bool = false {
        didSet {
            if isSaved {
                buttonSave.setTitle("Đã lưu", for: .normal)
                buttonSave.setTitleColor(UIColor.colorOrange, for: .normal)
                buttonSave.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
            } else {
                buttonSave.setTitle("Lưu Deal", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.colorOrange
            }
            labelUserSaved.animation = "zoomIn"
            labelUserSaved.animate()
        }
    }
    
    var totalLike: Int = 0 {
        didSet {
            var end = ""
            var value = totalLike
            if totalLike >= 1000 {
                end = "K"
                value = Int(Double(value) / 1000.0)
            }
            
            if totalLike >= 1000 {
                end = "M"
                value = Int(Double(value) / 1000.0)
            }
            
            labelLike.text = "\(value)\(end)"
        }
    }
    
    var totalSave: Int = 0 {
        didSet {
            let attributedText = NSMutableAttributedString()
            let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(15), NSForegroundColorAttributeName: UIColor.colorOrange]
            let variety1 = NSAttributedString(string: "\(NSString(format: "%i", totalSave))\n", attributes: attribute1)
            attributedText.append(variety1)
            
            let attribute2 = [NSFontAttributeName: UIFont.getFont(10), NSForegroundColorAttributeName: UIColor.colorOrange]
            let variety2 = NSAttributedString(string: "Saved", attributes: attribute2)
            attributedText.append(variety2)
            
            labelUserSaved.attributedText = attributedText
        }
    }
    
    var endAt: Double = 0 {
        didSet {
            let time = Int(Date(timeIntervalSince1970: TimeInterval(endAt / 1000.0)).timeIntervalSince(Date()))
            let (d, h, m) = time.secondsToDayHoursMinutes()
            
            if let attributedText = labelDate1.attributedText {
                labelDate1.attributedText = NSAttributedString(string: "\(d > 9 ? Int(d / 10) : 0)", attributes: attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length)))
            }
            if let attributedText = labelDate2.attributedText {
                labelDate2.attributedText = NSAttributedString(string: "\(d > 9 ? Int(d % 10) : d)", attributes: attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length)))
            }
            
            if let attributedText = labelHour1.attributedText {
                labelHour1.attributedText = NSAttributedString(string: "\(h > 9 ? Int(h / 10) : 0)", attributes: attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length)))
            }
            if let attributedText = labelHour2.attributedText {
                labelHour2.attributedText = NSAttributedString(string: "\(h > 9 ? Int(h % 10) : h)", attributes: attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length)))
            }
            
            if let attributedText = labelMinute1.attributedText {
                labelMinute1.attributedText = NSAttributedString(string: "\(m > 9 ? Int(m / 10) : 0)", attributes: attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length)))
            }
            if let attributedText = laberMinute2.attributedText {
                laberMinute2.attributedText = NSAttributedString(string: "\(m > 9 ? Int(m % 10) : m)", attributes: attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length)))
            }
        }
    }
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                if let shop = discover.shop {
                    if let shopAvatarUrl = shop.avatarUrl {
                        let cache = Shared.imageCache
                        let URL = NSURL(string: shopAvatarUrl)!
                        let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                        weak var _self = self
                        _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                            _self?.imageViewShopAvatar.image = image.cropToBounds(width: image.size.height, height: image.size.height)
                        })
                    }
                    
                    if let fullName = shop.fullName {
                        labelShopName.text = fullName
                    }
                    
                    if let addresses = shop.addresses {
                        if addresses.count != 0 {
                            if let address = addresses.first {
                                if let addressContent = address.addressContent {
                                    labelShopAddress.text = addressContent
                                }
                            }
                        }
                    }
                }
                
                if let image = discover.image, let urls = image.urls{
                    if let imageUrl = urls.first {
                        let cache = Shared.imageCache
                        let URL = NSURL(string: imageUrl)!
                        let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                        weak var _self = self
                        _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                            _self?.imageView1.image = image.cropToBounds(width: image.size.height, height: image.size.height * 2.0 / 3.0)
                        })
                    }
                }
                
                if let content = discover.content {
                    labelDescription.text = content
                }
                
                if let totalSaves = discover.totalSaves {
                    totalSave = totalSaves
                }
                
                isLiked = discover.isLiked ?? false
                
                isSaved = discover.isSave ?? false
                
                
                if let totalLikes = discover.totalLikes {
                    totalLike = totalLikes
                }
                
                if let endedAt = discover.endedAt {
                    endAt = endedAt
                }
                
                if let priceOld = discover.priceOld {
                    if let priceNew = discover.priceNew {
                        
                        if let discountRate = discover.discountRate {
                            let attributedText = NSMutableAttributedString()
                            let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(15), NSForegroundColorAttributeName: UIColor.white]
                            let variety1 = NSAttributedString(string: "\(NSString(format: "%.0f", discountRate))%\n", attributes: attribute1)
                            attributedText.append(variety1)
                            
                            let attribute2 = [NSFontAttributeName: UIFont.getFont(8), NSForegroundColorAttributeName: UIColor.white]
                            let variety2 = NSAttributedString(string: "OFF", attributes: attribute2)
                            attributedText.append(variety2)
                            
                            labelDiscount.attributedText = attributedText
                        }
                        
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .currency
                        formatter.locale = Locale(identifier: "es_VN")
                        formatter.currencySymbol = ""
                        
                        let attributedText = NSMutableAttributedString()
                        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(28), NSForegroundColorAttributeName: UIColor.colorOrange]
                        let variety1 = NSAttributedString(string: "\(NSString(format: "%@", formatter.string(from: NSNumber(value: priceNew))!))", attributes: attribute1)
                        attributedText.append(variety1)
                        
                        let attribute2 = [NSFontAttributeName: UIFont.getFont(15), NSForegroundColorAttributeName: UIColor.colorOrange]
                        let variety2 = NSAttributedString(string: "VND", attributes: attribute2)
                        attributedText.append(variety2)
                        
                        let attribute3 = [NSFontAttributeName: UIFont.getBoldFont(15), NSForegroundColorAttributeName: UIColor.gray]
                        let variety3 = NSAttributedString(string: "   \(NSString(format: "%@", formatter.string(from: NSNumber(value: priceOld))!))", attributes: attribute3)
                        attributedText.append(variety3)
                        
                        let attribute4 = [NSFontAttributeName: UIFont.getBoldFont(8), NSForegroundColorAttributeName: UIColor.gray]
                        let variety4 = NSAttributedString(string: "VND", attributes: attribute4)
                        attributedText.append(variety4)
                        
                        labelPrice.attributedText = attributedText
                    } else {
                        
                    }
                }
            }
        }
    }
    
    @IBAction func buttonLikeTapped(_ sender: AnyObject) {
        isLiked = !isLiked
        delegate?.likeDiscoverTapped(discover: discover)
    }
    
    @IBAction func buttonShareTapped(_ sender: AnyObject) {
        delegate?.shareDiscoverTapped(discover: discover)
    }
    
    @IBAction func buttonSaveDealTapped(_ sender: AnyObject) {
        delegate?.saveDiscoverTapped(discover: discover)
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        delegate?.discovertapped(discover: discover)
    }
}
