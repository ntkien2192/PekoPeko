//
//  MessageView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol MessageViewDelegate: class {
    func clossTapped()
}

class MessageView: UIView {

    weak var delegate: MessageViewDelegate?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonClose: Button!
    
    typealias MessageViewViewHandle = () -> Void
    
    var closeAction: MessageViewViewHandle?
    
    var message: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("MessageView", owner: self, options: nil)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonClose(_ title: String, action: @escaping MessageViewViewHandle) {
        closeAction = action
        buttonClose.setTitle(title, for: UIControlState())
    }
    
    @IBAction func buttonCloseTapped(_ sender: AnyObject) {
        weak var _self = self
        UIView.animate(withDuration: 0.2, animations: { 
            self.alpha = 0.0
            }) { _ in
                if let _self = _self {
                    
                    if !AuthenticationStore().isLogin {
                        HomeTabbarController.sharedInstance.logOut()
                    }
                    
                    if let closeAction = _self.closeAction {
                        closeAction()
                    }
                    _self.removeFromSuperview()
                }
        }
    }
}
