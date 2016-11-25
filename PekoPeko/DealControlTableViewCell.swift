//
//  DealControlTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit


protocol DealControlTableViewCellDelegate: class {
    func saveDiscoverTapped(discover: Discover?, isSaved: Bool, completionHandler: @escaping (Bool) -> Void)
    func likeDiscoverTapped(discover: Discover?, isLiked: Bool, completionHandler: @escaping (Bool) -> Void)
    func useDiscoverTapped(discover: Discover?, completionHandler: @escaping (Bool) -> Void)
}

class DealControlTableViewCell: UITableViewCell {

    static let identify = "DealControlTableViewCell"
    
    weak var delegate: DealControlTableViewCellDelegate?
    
    @IBOutlet weak var imageViewLike: ImageView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var labelUserSaved: Label!
    @IBOutlet weak var labelLike: UILabel!
    
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
            reloadDealStep()
            
            labelUserSaved.animation = "zoomIn"
            labelUserSaved.animate()
        }
    }
    
    var isUsed: Bool = false {
        didSet {
            if isUsed {
                buttonSave.setTitle("Đã sử dụng", for: .normal)
                buttonSave.setTitleColor(UIColor.colorOrange, for: .normal)
                buttonSave.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
            } else {
                buttonSave.setTitle("Sử Dụng", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.RGB(45, green: 204, blue: 112)
            }
        }
    }
    
    var isEnd = false {
        didSet {
            if isEnd {
                buttonSave.setTitle("Đã Hết Hạn", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.darkGray
            } else {
                buttonSave.setTitle("Lưu Deal", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.colorOrange
            }
        }
    }
    
    var isExpire: Bool = false {
        didSet {
            reloadDealStep()
        }
    }
    
    func reloadDealStep() {
        if isExpire {
            buttonSave.setTitle("Đã Hết Hạn", for: .normal)
            buttonSave.setTitleColor(UIColor.white, for: .normal)
            buttonSave.backgroundColor = UIColor.darkGray
        } else {
            if isSaved {
                isUsed = Bool(isUsed)
            } else {
                isEnd = Bool(isEnd)
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
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                if let totalSaves = discover.totalSaves {
                    totalSave = totalSaves
                }
                
                isLiked = discover.isLiked
                
                isUsed = discover.isUsed
                
                isSaved = discover.isSave
                
                isEnd = discover.isEnd
                
                isExpire = discover.isExpire
                
                if let totalLikes = discover.totalLikes {
                    totalLike = totalLikes
                }
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
                }
            }
        })
    }
    
    @IBAction func buttonSaveDealTapped(_ sender: AnyObject) {
        if !isExpire {
            if isSaved {
                if !isUsed {
                    weak var _self = self
                    delegate?.useDiscoverTapped(discover: discover, completionHandler: { (success) in
                        if let _self = _self, let discover = _self.discover {
                            if success {
                                discover.isUsed = true
                                _self.isUsed = true
                            }
                        }
                    })
                }
            } else {
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
                        }
                    }
                })
            }
        }
    }
}
