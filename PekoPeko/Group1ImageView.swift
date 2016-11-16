//
//  Group1ImageView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 01/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class Group1ImageView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrls: [String]? {
        didSet {
            if let imageUrls = imageUrls, let imageUrl = imageUrls.first {
                weak var _self = self
                DispatchQueue.main.async {
                    if let _self = _self {
                        _self.imageView.contentMode = .scaleAspectFill
                        _self.imageView.clipsToBounds = false
                        _self.imageView.layer.masksToBounds = true
                        
                        let cache = Shared.imageCache
                        let URL = NSURL(string: imageUrl)!
                        let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                        _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                            DispatchQueue.main.async {
                                _self.imageView.image = image
                            }
                        })
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("Group1ImageView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
