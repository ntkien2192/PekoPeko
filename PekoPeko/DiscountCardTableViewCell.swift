//
//  DiscountCardTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 13/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke
import SwiftDate

protocol DiscountCardTableViewCellDelegate: class {
    func discountCardCellTapped(card: Card?)
    func noMoreDiscountCardCellTapped(card: Card?)
}

class DiscountCardTableViewCell: UITableViewCell {

    static let identify = "DiscountCardTableViewCell"
    
    weak var delegate: DiscountCardTableViewCellDelegate?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewCover: ImageView!
    @IBOutlet weak var labelTotal: UILabel!
    
    var card: Card? {
        didSet {
            if let card = card, let discount = card.discount {
                
                if let coverUrl = discount.coverUrl {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: coverUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewCover.image = image
                    })
                }
                
                if let title = discount.title {
                    labelTitle.text = title
                }
                
                if let total = discount.total {
                    if total > 0 {
                        labelTotal.text = "x\(total)"
                        canAdd = true
                    } else {
                        labelTotal.text = "x0"
                        canAdd = false
                    }
                }
                
                if let isNeverEnd = discount.isNeverEnd {
                    if isNeverEnd {
                        labelDate.text = "Không Giới Hạn"
                    } else {
                        if let endedAt = discount.endedAt {
                            let time = Date(timeIntervalSince1970: endedAt / 1000)
                            let attributedText = NSMutableAttributedString()
                            let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(8), NSForegroundColorAttributeName: UIColor.gray]
                            let variety1 = NSAttributedString(string: "Kết thúc vào\n", attributes: attribute1)
                            attributedText.append(variety1)
                            
                            let attribute2 = [NSFontAttributeName: UIFont.getFont(10), NSForegroundColorAttributeName: UIColor.gray]
                            let variety2 = NSAttributedString(string: "\(time.string(custom: "dd/MM/yyyy"))", attributes: attribute2)
                            attributedText.append(variety2)
                            
                            labelDate.attributedText = attributedText
                        }
                    }
                }
            }
        }
    }
    
    var canAdd: Bool = true
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        if canAdd {
            delegate?.discountCardCellTapped(card: card)
        } else {
            delegate?.noMoreDiscountCardCellTapped(card: card)
        }
    }
}
