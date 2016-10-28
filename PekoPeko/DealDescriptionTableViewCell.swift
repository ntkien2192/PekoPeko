//
//  DealDescriptionTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class DealDescriptionTableViewCell: UITableViewCell {

    static let identify = "DealDescriptionTableViewCell"
    
    @IBOutlet weak var labelDescription: UILabel!

    var discover: Discover? {
        didSet {
            if let discover = discover {
                if let content = discover.content {
                    labelDescription.text = content
                }
            }
        }
    }
}
