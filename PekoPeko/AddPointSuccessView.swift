//
//  AddPointSuccessView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 20/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class AddPointSuccessView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var labelPointName: UILabel!
    @IBOutlet weak var imageViewCover: UIImageView!
    
    @IBOutlet weak var labelCardName: UILabel!
    @IBOutlet weak var labelCardAddress: UILabel!
    @IBOutlet weak var labelPointNumber: UILabel!
    @IBOutlet weak var buttonClose: Button!
    
    var card: Card?
    var honeyPot: Int?
    
    typealias AddPointViewViewHandle = () -> Void
    var closeAction: AddPointViewViewHandle?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AddPointSuccessView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let card = card {
            if let name = card.shopName {
                labelCardName.text = name
            }
            
            if let address = card.shopAddress {
                labelCardAddress.text = address
            }
            
            if let shopCoverUrl = card.shopCoverUrl {
                let cache = Shared.imageCache
                let URL = NSURL(string: shopCoverUrl)!
                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                weak var _self = self
                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                    if let _self = _self {
                        _self.imageViewCover.image = image.cropToBounds(width: image.size.width, height: image.size.width / 2.0)
                    }
                })
            }
        }
        
        if let honeyPot = honeyPot {
            labelPointNumber.text = "\(honeyPot)"
            labelPointName.text = "Bạn vừa tích được \(honeyPot)"
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonClose(_ title: String, action: @escaping AddPointViewViewHandle) {
        closeAction = action
        buttonClose.setTitle(title, for: UIControlState())
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        weak var _self = self
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }) { _ in
            
            if let _self = _self {
                if let closeAction = _self.closeAction {
                    closeAction()
                }
                _self.removeFromSuperview()
            }
        }
    }
}
