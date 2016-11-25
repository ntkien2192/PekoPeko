//
//  GroupMoreImageView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 01/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class GroupMoreImageView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    var imageUrls: [String]? {
        didSet {
            if let imageUrls = imageUrls {
                for i in 0..<imageUrls.count {
                    switch i {
                    case 0:
                        let imageUrl = imageUrls[i]
                        weak var _self = self
                        DispatchQueue.main.async {
                            if let _self = _self {
                                _self.imageView1.contentMode = .scaleAspectFill
                                _self.imageView1.clipsToBounds = false
                                _self.imageView1.layer.masksToBounds = true
                                
                                let cache = Shared.imageCache
                                let URL = NSURL(string: imageUrl)!
                                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                    _self.imageView1.image = image
                                })
                            }
                        }
                    case 1:
                        let imageUrl = imageUrls[i]
                        weak var _self = self
                        DispatchQueue.main.async {
                            if let _self = _self {
                                _self.imageView2.contentMode = .scaleAspectFill
                                _self.imageView2.clipsToBounds = false
                                _self.imageView2.layer.masksToBounds = true
                                
                                let cache = Shared.imageCache
                                let URL = NSURL(string: imageUrl)!
                                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                    _self.imageView2.image = image
                                })
                            }
                        }
                    case 2:
                        let imageUrl = imageUrls[i]
                        weak var _self = self
                        DispatchQueue.main.async {
                            if let _self = _self {
                                _self.imageView3.contentMode = .scaleAspectFill
                                _self.imageView3.clipsToBounds = false
                                _self.imageView3.layer.masksToBounds = true
                                
                                let cache = Shared.imageCache
                                let URL = NSURL(string: imageUrl)!
                                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                                    _self.imageView3.image = image
                                })
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("GroupMoreImageView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
