//
//  PointCatdTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 13/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class PointCardTableViewCell: UITableViewCell {

    static let identify = "PointCardTableViewCell"
    
    @IBOutlet weak var labelHPRate: UILabel!
    
    var card: Card? {
        didSet {
            if let card = card {
                if let hpRate = card.hpRate {
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .currency
                    formatter.locale = Locale(identifier: "es_VN")
                    
                    labelHPRate.text = "\(NSString(format: "%@ chi tiêu = 1", formatter.string(from: NSNumber(value: hpRate))!))"
                }
            }
        }
    }
}
