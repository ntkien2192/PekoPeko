//
//  DealMultiPriceCollectionViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 27/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class DealMultiPriceCollectionViewCell: UICollectionViewCell {

    static let identify = "DealMultiPriceCollectionViewCell"

    @IBOutlet weak var labeltext: UILabel!

    var text: String? {
        didSet {
            if let text = text {
                labeltext.text = text
            }
        }
    }
    
    var isTarget: Bool = false {
        didSet {
            if isTarget {
                labeltext.textColor = UIColor.colorOrange
                labeltext.font = UIFont.getBoldFont(14)
            } else {
                labeltext.textColor = UIColor.darkGray
                labeltext.font = UIFont.getFont(11)
            }
        }
    }
}
