//
//  InfoTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 17/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class ShopInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewAvatar: ImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    @IBOutlet weak var labelFollower: UILabel!
    @IBOutlet weak var buttonFollow: Button!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonFollowTapped(_ sender: AnyObject) {
    }
    
}
