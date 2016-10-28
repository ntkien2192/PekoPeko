//
//  CardView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class CardView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: ImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelVip: UILabel!
    @IBOutlet weak var backGroundImage: View!
    @IBOutlet weak var imageViewVip: ImageView!
    
    var vipCard: VipCard? {
        didSet {
            if let vipCard = vipCard {
                
                if let imageUrl = vipCard.imageUrl {
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = false
                    imageView.layer.masksToBounds = true
                    
                    if !imageUrl.isEmpty {
                        let cache = Shared.imageCache
                        let URL = NSURL(string: imageUrl)!
                        let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                        weak var _self = self
                        _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                            _self?.imageView.image = image
                        })
                    } else {
                        imageView.image = UIImage(named: "DefaultCellImage")
                    }
                }
                
                textView.text = vipCard.benefit ?? ""
                
                if vipCard.isLock {
                    labelVip.backgroundColor = UIColor.darkGray
                    labelVip.textColor = UIColor.white
                    backGroundImage.backgroundColor = UIColor.darkGray
                    imageViewVip.image = UIImage(named: "IconPadlock")
                    
                    labelVip.text = "Bạn cần thêm \(vipCard.needPoint ?? 0) điểm để lên cấp"
                } else {
                    if vipCard.isCurrent {
                        labelVip.backgroundColor = UIColor.RGB(45, green: 204, blue: 112)
                        labelVip.textColor = UIColor.white
                        backGroundImage.backgroundColor = UIColor.white
                        imageViewVip.image = UIImage(named: "IconCheckVIP")
                        
                        labelVip.text = "Bạn đang được hưởng quyền lợi VIP"
                    } else {
                        labelVip.backgroundColor = UIColor.white
                        labelVip.textColor = UIColor.darkGray
                        backGroundImage.backgroundColor = UIColor.darkGray
                        imageViewVip.image = UIImage(named: "IconUsesVIP")
                        
                        labelVip.text = "Đã qua sử dụng"
                    }
                }
            }
        }
    }
    
    var user: User? {
        didSet {
            if let user = user {
                if let fullName = user.fullName {
                    labelName.text = fullName
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        textView.isSelectable = false
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
}
