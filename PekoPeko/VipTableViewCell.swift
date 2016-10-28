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
    
    weak var delegate: VipTableViewCellDelegate?
    
    var card: Card?
    
    @IBAction func buttonVipTapped(_ sender: AnyObject) {
        delegate?.vipCellTapped(card: card)
    }
}
