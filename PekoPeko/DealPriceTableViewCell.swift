//
//  DealPriceTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class DealPriceTableViewCell: UITableViewCell {

    static let identify = "DealPriceTableViewCell"
    
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var labelPrice: UILabel!

    var discover: Discover? {
        didSet {
            if let discover = discover {
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
    }

}
