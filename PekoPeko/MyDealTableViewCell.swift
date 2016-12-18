//
//  MyDealTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 29/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol MyDealTableViewCellDelegate: class {
    func moreDiscoverTapped(discover: Discover?)
    func useDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
    func discoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
    func likeDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
}

class MyDealTableViewCell: UITableViewCell {
    
    static let identify = "MyDealTableViewCell"
    
    weak var delegate: MyDealTableViewCellDelegate?
    
    @IBOutlet weak var constraintLineBottonHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewShopAvatar: ImageView!
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopAddress: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelUserSaved: Label!
    @IBOutlet weak var buttonUse: UIButton!
    @IBOutlet weak var buttonMore: UIButton!
    
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
    
    var isUsed: Bool = false
    
    var dealStep: DealStep = .begin {
        didSet {
            switch dealStep {
            case .canUse:
                buttonMore.isHidden = false
                buttonUse.setTitle("Sử Dụng", for: .normal)
                buttonUse.setTitleColor(UIColor.white, for: .normal)
                buttonUse.backgroundColor = UIColor.RGB(45, green: 204, blue: 112)
            case .used:
                buttonMore.isHidden = true
                buttonUse.setTitle("Đã sử dụng", for: .normal)
                buttonUse.setTitleColor(UIColor.colorOrange, for: .normal)
                buttonUse.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
            case .close:
                buttonMore.isHidden = true
                buttonUse.setTitle("Đã hết hạn", for: .normal)
                buttonUse.setTitleColor(UIColor.white, for: .normal)
                buttonUse.backgroundColor = UIColor.darkGray
            default:
                break
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
            weak var _self = self
            DispatchQueue.main.async {
                if let _self = _self {
                    if let attributedText = _self.labelDate1.attributedText {
                        let attributes = attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributedText.length))
                        _self.labelDate1.attributedText = NSAttributedString(string: "\(d > 9 ? Int(d / 10) : 0)", attributes: attributes)
                        _self.labelDate2.attributedText = NSAttributedString(string: "\(d > 9 ? Int(d % 10) : d)", attributes: attributes)
                        _self.labelHour1.attributedText = NSAttributedString(string: "\(h > 9 ? Int(h / 10) : 0)", attributes: attributes)
                        _self.labelHour2.attributedText = NSAttributedString(string: "\(h > 9 ? Int(h % 10) : h)", attributes: attributes)
                        _self.labelMinute1.attributedText = NSAttributedString(string: "\(m > 9 ? Int(m / 10) : 0)", attributes: attributes)
                        _self.laberMinute2.attributedText = NSAttributedString(string: "\(m > 9 ? Int(m % 10) : m)", attributes: attributes)
                    }
                }
            }
        }
    }
    
    var images: [String]? {
        didSet {
            if let images = images {
                
                for view in groupImageView.subviews {
                    view.removeFromSuperview()
                }
                
                if images.count == 1 {
                    
                    let group1ImageView = Group1ImageView(frame: groupImageView.bounds)
                    group1ImageView.imageUrls = images
                    groupImageView.addSubview(group1ImageView)
                    
                    weak var _self = self
                    DispatchQueue.main.async {
                        if let _self = _self {
                            group1ImageView.translatesAutoresizingMaskIntoConstraints = false
                            _self.groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group1ImageView]))
                            _self.groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group1ImageView]))
                        }
                    }
                } else if isMoreImage {
                    let groupMoreImageView = GroupMoreImageView(frame: groupImageView.bounds)
                    groupMoreImageView.imageUrls = images
                    groupImageView.addSubview(groupMoreImageView)
                    
                    weak var _self = self
                    DispatchQueue.main.async {
                        if let _self = _self {
                            groupMoreImageView.translatesAutoresizingMaskIntoConstraints = false
                            _self.groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": groupMoreImageView]))
                            _self.groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": groupMoreImageView]))
                        }
                    }
                } else {
                    let group3ImageView = Group3ImageView(frame: groupImageView.bounds)
                    group3ImageView.imageUrls = images
                    groupImageView.addSubview(group3ImageView)
                    weak var _self = self
                    DispatchQueue.main.async {
                        if let _self = _self {
                            group3ImageView.translatesAutoresizingMaskIntoConstraints = false
                            _self.groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group3ImageView]))
                            _self.groupImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": group3ImageView]))
                        }
                    }
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
                    weak var _self = self
                    DispatchQueue.main.async {
                        if let _self = _self {
                            _self.imageViewShopAvatar.contentMode = .scaleAspectFill
                            _self.imageViewShopAvatar.clipsToBounds = false
                            _self.imageViewShopAvatar.layer.masksToBounds = true
                            
                            let cache = Shared.imageCache
                            let URL = NSURL(string: shopAvatarUrl)!
                            let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                            _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                _self.imageViewShopAvatar.image = image.resizeImage(targetSize: CGSize(width: 80, height: 80))
                            })
                        }
                    }
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
            
            isUsed = discover.isUsed
            
            dealStep = discover.step
            
            totalLike = discover.totalLikes ?? 0
            
            endAt = discover.endedAt ?? (0, 0, 0)
            
            if let priceOld = discover.priceOld {
                var newPrice = 0.0
                
                if let priceNew = discover.priceNew {
                    newPrice = Double(priceNew)
                } else {
                    if let step = discover.currentStep(), let priceNew = step.priceNew {
                        newPrice = Double(priceNew)
                    } else if let step = discover.firstStep(), let priceNew = step.priceNew {
                        newPrice = Double(priceNew)
                    }
                }
                
                weak var _self = self
                
                DispatchQueue.main.async {
                    if let _self = _self {
                        if let discountRate = discover.discountRate {
                            if discountRate != 0 {
                                _self.imageViewDiscount.isHidden = false
                                _self.labelDiscount.isHidden = false
                                let attributedText = NSMutableAttributedString()
                                let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(15), NSForegroundColorAttributeName: UIColor.white]
                                let variety1 = NSAttributedString(string: "\(NSString(format: "%.0f", discountRate))%\n", attributes: attribute1)
                                attributedText.append(variety1)
                                
                                let attribute2 = [NSFontAttributeName: UIFont.getFont(8), NSForegroundColorAttributeName: UIColor.white]
                                let variety2 = NSAttributedString(string: "OFF", attributes: attribute2)
                                attributedText.append(variety2)
                                
                                _self.labelDiscount.attributedText = attributedText
                            } else {
                                _self.imageViewDiscount.isHidden = true
                                _self.labelDiscount.isHidden = true
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    if let _self = _self {
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
                        
                        _self.labelPrice.attributedText = attributedText
                    }
                }
            }
        }

    }
    
    @IBAction func buttonLikeTapped(_ sender: AnyObject) {
        weak var _self = self
        delegate?.likeDiscoverTapped(discover: discover, completionHandler: { newDiscover in
            if let _self = _self {
                
                if let newDiscover = newDiscover {
                    _self.isLiked = newDiscover.updateLike()
                    _self.imageViewLike.animation = "zoomIn"
                    _self.imageViewLike.animate()
                }
                
                _self.discover = newDiscover
            }
        })
    }
    
    @IBAction func buttonMoreTapped(_ sender: AnyObject) {
        delegate?.moreDiscoverTapped(discover: discover)
    }
    
    @IBAction func buttonUseDealTapped(_ sender: AnyObject) {
        if let discover = discover {
            if discover.step == .canUse {
                weak var _self = self
                delegate?.useDiscoverTapped(discover: discover, completionHandler: { newDiscover in
                    if let _self = _self {
                        _self.discover = newDiscover
                    }
                })
            }
        }
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        weak var _self = self
        delegate?.discoverTapped(discover: discover, completionHandler: { newDiscover in
            if let _self = _self {
                _self.discover = newDiscover
            }
        })
    }
}
