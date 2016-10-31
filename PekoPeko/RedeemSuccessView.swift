//
//  RedeemSuccessView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol RedeemSuccessViewDelegate: class {
    func buttonBackTapped()
}

class RedeemSuccessView: UIView {

    weak var delegate: RedeemSuccessViewDelegate?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var labelRedeemName: UILabel!

    @IBOutlet weak var labelCardName: UILabel!
    @IBOutlet weak var labelCardAddress: UILabel!
    
    var card: Card?
    var reward: Reward?
    var voucher: Voucher?
    var deal: Discover?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("RedeemSuccessView", owner: self, options: nil)
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
            
            if let addresses = card.addressList, let address = addresses.last, let addressContent = address.addressContent {
                labelCardAddress.text = addressContent
            }
        }
        
        if let reward = reward, let title = reward.title {
            labelRedeemName.text = title
        }
        
        if let voucher = voucher, let title = voucher.title {
            labelRedeemName.text = title
        }
        
        if let deal = deal, let name = deal.name {
            labelRedeemName.text = name
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        delegate?.buttonBackTapped()
    }
}


