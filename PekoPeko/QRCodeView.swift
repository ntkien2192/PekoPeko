//
//  QRCodeView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 04/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class QRCodeView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var content: String? {
        didSet {
            if let content = content {
                imageView.setQRCode(content: content)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("QRCodeView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @IBAction func buttonCloseTapped(_ sender: AnyObject) {
        weak var _self = self
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }) { _ in
            _self?.removeFromSuperview()
        }
    }
}
