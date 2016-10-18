//
//  ShopMenuShowMoreTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol ShopMenuShowMoreTableViewCellDelegate: class {
    func showMoreTapped()
}

class ShopMenuShowMoreTableViewCell: UITableViewCell {
    static let identify = "ShopMenuShowMoreTableViewCell"
    
    weak var delegate: ShopMenuShowMoreTableViewCellDelegate?
    
    @IBAction func buttonShowMenuTapped(_ sender: AnyObject) {
        delegate?.showMoreTapped()
    }
}
