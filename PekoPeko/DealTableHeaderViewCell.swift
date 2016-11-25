//
//  DealTableHeaderViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol DealTableHeaderViewCellDelegate: class {
    func discoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
}

class DealTableHeaderViewCell: UICollectionViewCell {

    static let identify = "DealTableHeaderViewCell"
    
    weak var delegate: DealTableHeaderViewCellDelegate?
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                
                if let coverImage = discover.coverImage {
                    weak var _self = self
                    DispatchQueue.main.async {
                        if let _self = _self {
                            _self.imageView.contentMode = .scaleAspectFill
                            _self.imageView.clipsToBounds = false
                            _self.imageView.layer.masksToBounds = true
                            
                            let cache = Shared.imageCache
                            let URL = NSURL(string: coverImage)!
                            let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                            _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                DispatchQueue.main.async {
                                    _self.imageView.image = image
                                }
                            })
                        }
                    }
                }
                
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
                    
                    weak var _self = self
                    
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
    }
    
    @IBAction func buttonCellTapped(_ sender: Any) {
        weak var _self = self
        delegate?.discoverTapped(discover: discover, completionHandler: { newDiscover in
            if let _self = _self {
                _self.discover = newDiscover
            }
        })
    }
}
