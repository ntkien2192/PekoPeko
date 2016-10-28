//
//  DealImageTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import iCarousel

protocol DealImageTableViewCellDelegate: class {
    func imageTapped(image: UIImage?)
}

class DealImageTableViewCell: UITableViewCell {

    static let identify = "DealImageTableViewCell"
    
    weak var delegate: DealImageTableViewCellDelegate?
    
    @IBOutlet weak var cardView: iCarousel!
    
    var images: [String]? {
        didSet {
            if let images = images {
                var tempViewImage = [DealImageView]()
                for image in images {
                    let view = DealImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height))
                    view.imageUrl = image
                    tempViewImage.append(view)
                }
                viewImage = tempViewImage
            }
        }
    }
    
    var viewImage: [DealImageView]? {
        didSet {
            if viewImage != nil {
                cardView.reloadData()
            }
        }
    }
    
    var isMoreImage: Bool = false
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                if let images = discover.images {
                    
                    var link = [String]()
                    
                    for image in images {
                        link.append(image.url ?? "")
                    }
                    
                    self.images = link
                    
                    if link.count > 3 {
                        isMoreImage = true
                    }
                }
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.type = .rotary
    }
    
}

extension DealImageTableViewCell: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        if let viewImage = viewImage {
            return viewImage.count
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if let viewImage = viewImage {
            return viewImage[index]
        }
        return UIView()
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if let viewImage = viewImage, let image = viewImage[index].image {
            delegate?.imageTapped(image: image)
        }
    }
}
