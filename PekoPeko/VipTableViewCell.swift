//
//  DealVipTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol VipTableViewCellDelegate: class {
    func vipCellTapped(card: Card?)
}

class VipTableViewCell: UITableViewCell {

    static let identify = "VipTableViewCell"
    
    @IBOutlet weak var labelHPCurrent: UILabel!
    @IBOutlet weak var labelHPRequire: UILabel!
    
    weak var delegate: VipTableViewCellDelegate?
    
    var card: Card? {
        didSet {
            if let card = card, let vipCards = card.vipCards {
                for vipCard in vipCards {
                    if vipCard.isLock {
                        if let hpRequire = vipCard.hpRequire {
                            labelHPRequire.text = "\(NSString(format: "%i", hpRequire))"
                        }
                        
                        if let totalHP = card.totalHp {
                            labelHPCurrent.text = "\(NSString(format: "%i", totalHP))"
                        }
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func buttonVipTapped(_ sender: AnyObject) {
        delegate?.vipCellTapped(card: card)
    }
}
