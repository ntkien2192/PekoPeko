//
//  DealTimeTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class DealTimeTableViewCell: UITableViewCell {

    static let identify = "DealTimeTableViewCell"
    
    @IBOutlet weak var labelDate1: Label!
    @IBOutlet weak var labelDate2: Label!
    @IBOutlet weak var labelHour1: Label!
    @IBOutlet weak var labelHour2: Label!
    @IBOutlet weak var labelMinute1: Label!
    @IBOutlet weak var laberMinute2: Label!
    @IBOutlet weak var labelName: UILabel!
    
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
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                if let endedAt = discover.endedAt {
                    endAt = endedAt
                }
                
                if let name = discover.name {
                    labelName.text = name
                }
            }
        }
    }
    
}
