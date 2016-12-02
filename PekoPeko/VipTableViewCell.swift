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
    @IBOutlet weak var dotLine: UIImageView!
    @IBOutlet weak var honeyPot: UIImageView!
    @IBOutlet weak var labelMax: UILabel!
    
    weak var delegate: VipTableViewCellDelegate?
    
    var card: Card? {
        didSet {
            if let card = card, let vipCards = card.vipCards {
                
                var isMaxVIP = true
                
                for vipCard in vipCards {
                    if vipCard.isLock {
                        isMaxVIP = false
                        if let hpRequire = vipCard.hpRequire {
                            labelHPRequire.text = "\(NSString(format: "%i", hpRequire))"
                        }
                        
                        if let totalHP = card.totalHp {
                            labelHPCurrent.text = "\(NSString(format: "%i", totalHP))"
                        }
                        break
                    }
                }
                
                if isMaxVIP {
                    labelHPCurrent.isHidden = true
                    labelHPRequire.isHidden = true
                    dotLine.isHidden = true
                    honeyPot.isHidden = true
                    labelMax.isHidden = false
                } else {
                    labelHPCurrent.isHidden = false
                    labelHPRequire.isHidden = false
                    dotLine.isHidden = false
                    honeyPot.isHidden = false
                    labelMax.isHidden = true
                }
            }
        }
    }
    
    @IBAction func buttonVipTapped(_ sender: AnyObject) {
        delegate?.vipCellTapped(card: card)
    }
}
