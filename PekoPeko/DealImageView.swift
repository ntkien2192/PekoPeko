//
//  DealImageView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class DealImageView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            if let imageUrl = imageUrl {
                if !imageUrl.isEmpty {
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = false
                    imageView.layer.masksToBounds = true
                    
                    let cache = Shared.imageCache
                    let URL = NSURL(string: imageUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        if let _self = _self {
                            _self.image = image
                        }
                    })
                } else {
                    imageView.image = UIImage(named: "DefaultCellImage")
                }
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("DealImageView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
