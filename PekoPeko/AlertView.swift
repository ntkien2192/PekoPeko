//
//  AlertView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonSubmit: Button!
    
    typealias AlertViewViewHandle = () -> Void
    
    var submitAction: AlertViewViewHandle?
    
    var message: String?
    var submitTitle: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let message = message {
            labelMessage.text = message
        }
        
        if let submitTitle = submitTitle {
            buttonSubmit.setTitle(submitTitle, for: .normal)
        }
    }
    
    func setButtonSubmit(_ title: String, action: @escaping AlertViewViewHandle) {
        submitAction = action
        buttonSubmit.setTitle(title, for: UIControlState())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func buttonSubmitTApped(_ sender: AnyObject) {
        weak var _self = self
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }) { _ in
            if let submitAction = _self?.submitAction {
                submitAction()
            }
            _self?.removeFromSuperview()
        }
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
