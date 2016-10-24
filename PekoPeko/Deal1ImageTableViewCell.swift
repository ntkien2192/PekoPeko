//
//  Deal1ImageTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol Deal1ImageTableViewCellDelegate: class {
    func shareDiscoverTapped(discover: Discover?)
    func saveDiscoverTapped(discover: Discover?)
    func discoverTapped(discover: Discover?)
    func likeDiscoverTapped(discover: Discover?)
}

class Deal1ImageTableViewCell: UITableViewCell {
    
    static let identify = "Deal1ImageTableViewCell"
    
    weak var delegate: Deal1ImageTableViewCellDelegate?
    
    @IBOutlet weak var constraintLineBottonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewShopAvatar: ImageView!
    @IBOutlet weak var imageView1: ImageView!
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopAddress: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelUserSaved: UILabel!
    @IBOutlet weak var buttonSave: UIButton!
    
    @IBOutlet weak var labelDate1: Label!
    @IBOutlet weak var labelDate2: Label!
    @IBOutlet weak var labelHour1: Label!
    @IBOutlet weak var labelHour2: Label!
    @IBOutlet weak var labelMinute1: Label!
    @IBOutlet weak var laberMinute2: Label!
    
    @IBOutlet weak var imageViewLike: ImageView!
    @IBOutlet weak var labelLike: UILabel!
    
    var isLast: Bool = false {
        didSet {
            if isLast {
                constraintLineBottonHeight.constant = 0.0
            } else {
                constraintLineBottonHeight.constant = 20.0
            }
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                imageViewLike.image = UIImage(named: "IconLiked")
            } else {
                imageViewLike.image = UIImage(named: "IconLike")
                
            }
            imageViewLike.animation = "zoomIn"
            imageViewLike.animate()
        }
    }
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                
            }
        }
    }
    
    @IBAction func buttonLikeTapped(_ sender: AnyObject) {
        isLiked = !isLiked
        delegate?.likeDiscoverTapped(discover: discover)
    }
    
    @IBAction func buttonShareTapped(_ sender: AnyObject) {
        delegate?.shareDiscoverTapped(discover: discover)
    }
    
    @IBAction func buttonSaveDealTapped(_ sender: AnyObject) {
        delegate?.saveDiscoverTapped(discover: discover)
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        delegate?.discoverTapped(discover: discover)
    }
}
