//
//  ShareView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol ShareViewDelegate: class {
    func prompCodeTapped(promoCode: String?)
    func facebookTapped(promoCode: String?)
    func googlePlusTapped(promoCode: String?)
    func mailTapped(promoCode: String?)
    func smsTapped(promoCode: String?)
}

class ShareView: UIView {

    weak var delegate: ShareViewDelegate?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var labelPromoCode: Button!
    
    var promoCode: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ShareView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let promoCode = promoCode {
            labelPromoCode.setTitle(promoCode, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func buttonHideTapped(_ sender: AnyObject) {
        weak var _self = self
        UIView.animate(withDuration: 0.2, animations: {
            _self?.alpha = 0.0
        }) { _ in
            _self?.removeFromSuperview()
        }
    }
    
    @IBAction func buttonCodeTapped(_ sender: AnyObject) {
        delegate?.prompCodeTapped(promoCode: promoCode)
    }
    
    @IBAction func buttonFacebookTapped(_ sender: AnyObject) {
        delegate?.facebookTapped(promoCode: promoCode)
    }
    
    @IBAction func buttonGoogleTapped(_ sender: AnyObject) {
        delegate?.googlePlusTapped(promoCode: promoCode)
    }
    
    @IBAction func buttonMailTapped(_ sender: AnyObject) {
        delegate?.mailTapped(promoCode: promoCode)
    }
    
    @IBAction func buttonSMSTapped(_ sender: AnyObject) {
        delegate?.smsTapped(promoCode: promoCode)
    }
    
}
