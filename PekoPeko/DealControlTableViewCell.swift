//
//  DealControlTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit


protocol DealControlTableViewCellDelegate: class {
    func saveDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
    func likeDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
    func useDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
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
        }
    }
    
    var isSaved: Bool = false
    
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
    
    var dealStep: DealStep = .begin {
        didSet {
            switch dealStep {
            case .begin:
                buttonSave.setTitle("Chưa bắt đầu", for: .normal)
                buttonSave.setTitleColor(UIColor.colorYellow, for: .normal)
                buttonSave.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
            case .canSave:
                buttonSave.setTitle("Lưu Deal", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.colorOrange
            case .canUse:
                buttonSave.setTitle("Sử Dụng", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.RGB(45, green: 204, blue: 112)
            case .used:
                buttonSave.setTitle("Đã sử dụng", for: .normal)
                buttonSave.setTitleColor(UIColor.colorOrange, for: .normal)
                buttonSave.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
            case .close:
                buttonSave.setTitle("Đã hết hạn", for: .normal)
                buttonSave.setTitleColor(UIColor.white, for: .normal)
                buttonSave.backgroundColor = UIColor.darkGray
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
                
                dealStep = discover.step
                
                if let totalLikes = discover.totalLikes {
                    totalLike = totalLikes
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
    
    @IBAction func buttonSaveDealTapped(_ sender: AnyObject) {
        switch dealStep {
        case .canUse:
            weak var _self = self
            delegate?.useDiscoverTapped(discover: discover, completionHandler: { newDiscover in
                if let _self = _self {
                    
                    if let newDiscover = newDiscover {
                        _self.isUsed = newDiscover.updateUse()
                        _self.imageViewLike.animation = "zoomIn"
                        _self.imageViewLike.animate()
                    }
                    
                    _self.discover = newDiscover
                }
            })
        case .canSave:
            weak var _self = self
            delegate?.saveDiscoverTapped(discover: discover, completionHandler: { newDiscover in
                if let _self = _self {
                    
                    if let newDiscover = newDiscover {
                        _self.isSaved = newDiscover.updateSave()
                        _self.labelUserSaved.animation = "zoomIn"
                        _self.labelUserSaved.animate()
                    }
                    
                    _self.discover = newDiscover
                }
            })
        default:
            break
        }
    }
}
