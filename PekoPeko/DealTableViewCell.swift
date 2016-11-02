//
//  DealTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol DealTableViewCellDelegate: class {
    func saveDiscoverTapped(discover: Discover?, isSaved: Bool, completionHandler: @escaping (Bool) -> Void)
    func discoverTapped(discover: Discover?, completionHandler: @escaping () -> Void)
    func likeDiscoverTapped(discover: Discover?, isLiked: Bool, completionHandler: @escaping (Bool) -> Void)
}

class DealTableViewCell: UITableViewCell {
    
    static let identify = "DealTableViewCell"
    
    weak var delegate: DealTableViewCellDelegate?
    
    @IBOutlet weak var constraintLineBottonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewShopAvatar: ImageView!
    
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
    @IBOutlet weak var imageViewDiscount: UIImageView!
    @IBOutlet weak var groupImageView: UIView!
    
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
        }
    }
    
    var isSaved: Bool = false
    var isUsed: Bool = false
    var isEnd: Bool = false
    
    func reloadDealStep() {
        if isEnd {
            buttonSave.setTitle("Đã hết hạn", for: .normal)
            buttonSave.setTitleColor(UIColor.white, for: .normal)
            buttonSave.backgroundColor = UIColor.darkGray
        } else {
            if isSaved {
                if isUsed {
                    buttonSave.setTitle("Đã sử dụng", for: .normal)
                    buttonSave.setTitleColor(UIColor.colorOrange, for: .normal)
                    buttonSave.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
                } else {
                    buttonSave.setTitle("Đã lưu", for: .normal)
                    buttonSave.setTitleColor(UIColor.colorOrange, for: .normal)
                    buttonSave.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
                }
            } else {
                buttonSave.setTitle("Lưu Deal", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.colorOrange
            }
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
    
    var endAt: (Int, Int, Int) = (0, 0, 0) {
        didSet {
            let (d, h, m) = endAt
            
            if let attributedText = labelDate1.attributedText {
                let attributes = attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length))
                labelDate1.attributedText = NSAttributedString(string: "\(d > 9 ? Int(d / 10) : 0)", attributes: attributes)
                labelDate2.attributedText = NSAttributedString(string: "\(d > 9 ? Int(d % 10) : d)", attributes: attributes)
                labelHour1.attributedText = NSAttributedString(string: "\(h > 9 ? Int(h / 10) : 0)", attributes: attributes)
                labelHour2.attributedText = NSAttributedString(string: "\(h > 9 ? Int(h % 10) : h)", attributes: attributes)
                labelMinute1.attributedText = NSAttributedString(string: "\(m > 9 ? Int(m / 10) : 0)", attributes: attributes)
                laberMinute2.attributedText = NSAttributedString(string: "\(m > 9 ? Int(m % 10) : m)", attributes: attributes)
            }
        }
    }
    
    var images: [String]? {
        didSet {
            if let images = images {
                if images.count == 1 {
                    let group1ImageView = Group1ImageView(frame: groupImageView.bounds)
                    group1ImageView.imageUrls = images
                    groupImageView.addSubview(group1ImageView)
                    group1ImageView.translatesAutoresizingMaskIntoConstraints = false
                    groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group1ImageView]))
                    groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group1ImageView]))
                    
                } else if isMoreImage {
                    let groupMoreImageView = GroupMoreImageView(frame: groupImageView.bounds)
                    groupMoreImageView.imageUrls = images
                    groupImageView.addSubview(groupMoreImageView)
                    groupMoreImageView.translatesAutoresizingMaskIntoConstraints = false
                    groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": groupMoreImageView]))
                    groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": groupMoreImageView]))
                } else {
                    let group3ImageView = Group3ImageView(frame: groupImageView.bounds)
                    group3ImageView.imageUrls = images
                    groupImageView.addSubview(group3ImageView)
                    group3ImageView.translatesAutoresizingMaskIntoConstraints = false
                    groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group3ImageView]))
                    groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group3ImageView]))
                }
            }
        }
    }
    
    var isMoreImage: Bool = false
    
    var discover: Discover? {
        didSet {
            reloadData()
        }
    }
    
    func reloadData() {
        if let discover = discover {
            if let shop = discover.shop {
                if let shopAvatarUrl = shop.avatarUrl {
                    imageViewShopAvatar.contentMode = .scaleAspectFill
                    imageViewShopAvatar.clipsToBounds = false
                    imageViewShopAvatar.layer.masksToBounds = true
                    
                    let cache = Shared.imageCache
                    let URL = NSURL(string: shopAvatarUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewShopAvatar.image = image.resizeImage(targetSize: CGSize(width: 80, height: 80))
                    })
                }
                
                if let fullName = shop.fullName {
                    labelShopName.text = fullName
                }
                
                if let address = shop.address, let addressContent = address.addressContent {
                    labelShopAddress.text = addressContent
                }
            }
            
            if let image = discover.image, let urls = image.urls {
                images = urls
                
                if image.extant != 0 {
                    isMoreImage = true
                }
            }
            
            labelDescription.text = discover.content ?? ""
            
            totalSave = discover.totalSaves ?? 0
            
            isLiked = discover.isLiked
            
            isSaved = discover.isSave
            
            isUsed = discover.isUsed
            
            isEnd = discover.isEnd
            
            reloadDealStep()
            
            totalLike = discover.totalLikes ?? 0
            
            endAt = discover.endedAt ?? (0, 0, 0)
            
            if let priceOld = discover.priceOld {
                var newPrice: Float = 0.0
                
                if let priceNew = discover.priceNew {
                    newPrice = priceNew
                } else {
                    if let step = discover.currentStep(), let priceNew = step.priceNew {
                        newPrice = priceNew
                    } else if let step = discover.firstStep(), let priceNew = step.priceNew {
                        newPrice = priceNew
                    }
                }
                
                if let discountRate = discover.discountRate {
                    if discountRate != 0 {
                        imageViewDiscount.isHidden = false
                        labelDiscount.isHidden = false
                        let attributedText = NSMutableAttributedString()
                        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(15), NSForegroundColorAttributeName: UIColor.white]
                        let variety1 = NSAttributedString(string: "\(NSString(format: "%.0f", discountRate))%\n", attributes: attribute1)
                        attributedText.append(variety1)
                        
                        let attribute2 = [NSFontAttributeName: UIFont.getFont(8), NSForegroundColorAttributeName: UIColor.white]
                        let variety2 = NSAttributedString(string: "OFF", attributes: attribute2)
                        attributedText.append(variety2)
                        
                        labelDiscount.attributedText = attributedText
                    } else {
                        imageViewDiscount.isHidden = true
                        labelDiscount.isHidden = true
                    }
                }
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "es_VN")
                formatter.currencySymbol = ""
                
                let attributedText = NSMutableAttributedString()
                let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(28), NSForegroundColorAttributeName: UIColor.colorOrange]
                let variety1 = NSAttributedString(string: "\(NSString(format: "%@", formatter.string(from: NSNumber(value: newPrice))!))", attributes: attribute1)
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
            }
        }
    }
    
    @IBAction func buttonLikeTapped(_ sender: AnyObject) {
        weak var _self = self
        delegate?.likeDiscoverTapped(discover: discover, isLiked: isLiked, completionHandler: { (success) in
            if let _self = _self, let discover = _self.discover {
                if success {
                    if _self.isLiked {
                        discover.isLiked = false
                        discover.totalLikes = (discover.totalLikes ?? 1) - 1
                        
                    } else {
                        discover.isLiked = true
                        discover.totalLikes = (discover.totalLikes ?? 0) + 1
                    }
                    _self.totalLike = discover.totalLikes ?? 0
                    _self.isLiked = !_self.isLiked
                    _self.imageViewLike.animation = "zoomIn"
                    _self.imageViewLike.animate()
                    
                    _self.reloadData()
                }
            }
        })
    }
    
    @IBAction func buttonSaveDealTapped(_ sender: AnyObject) {
        if !isEnd && !isUsed {
            weak var _self = self
            delegate?.saveDiscoverTapped(discover: discover, isSaved: isSaved, completionHandler: { (success) in
                if let _self = _self, let discover = _self.discover {
                    if success {
                        if _self.isSaved {
                            discover.isSave = false
                            discover.totalSaves = (discover.totalSaves ?? 1) - 1
                            
                        } else {
                            discover.isSave = true
                            discover.totalSaves = (discover.totalSaves ?? 0) + 1
                        }
                        _self.totalSave = discover.totalSaves ?? 0
                        _self.isSaved = !_self.isSaved
                        _self.labelUserSaved.animation = "zoomIn"
                        _self.labelUserSaved.animate()
                        
                        _self.reloadData()
                    }
                }
            })
        }
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        weak var _self = self
        delegate?.discoverTapped(discover: discover, completionHandler: {
            if let _self = _self {
                _self.reloadData()
            }
        })
    }
}
