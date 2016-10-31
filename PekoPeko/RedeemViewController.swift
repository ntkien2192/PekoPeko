//
//  RedeemViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 13/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

enum RedeemType: Int {
    case gift = 0
    case voucher = 1
    case deal = 2
}

class RedeemViewController: BaseViewController {
    
    static let storyboardName = "Redeem"
    static let identify = "RedeemViewController"
    
    typealias RedeemViewControllerHandle = () -> Void
    var successAction: RedeemViewControllerHandle?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelRedeemName: Label!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    
    @IBOutlet weak var textfieldCode1: Textfield!
    @IBOutlet weak var textfieldCode2: Textfield!
    @IBOutlet weak var textfieldCode3: Textfield!
    @IBOutlet weak var textfieldCode4: Textfield!
    @IBOutlet weak var textfieldCode5: Textfield!
    @IBOutlet weak var textfieldCode6: Textfield!
    
    var card: Card?
    var reward: Reward?
    var voucher: Voucher? {
        didSet {
            if let voucher = voucher, let shop = voucher.shop {
                card = Card(shop: shop)
                redeemType = .voucher
            }
        }
    }
    var deal: Discover? {
        didSet {
            if let deal = deal, let shop = deal.shop {
                card = Card(shop: shop)
                redeemType = .deal
            }
        }
    }
    
    var redeemType: RedeemType = .gift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRedeemInfo()
    }
    
    override func viewConfig() {
        super.viewConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(RedeemViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RedeemViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setSuccessHandle(action: @escaping RedeemViewControllerHandle) {
        successAction = action
    }
    
    func loadRedeemInfo() {
        
        if let card = card, let shopName = card.shopName{
            labelTitle.text = shopName
        }
        
        if let reward = reward {
            labelRedeemName.text = reward.title ?? ""
        }
        
        if let voucher = voucher {
            labelRedeemName.text = voucher.title ?? ""
        }
        
        if deal != nil {
            labelRedeemName.text = "Sử dụng Deal"
        }
    }
    
    func sentRedeem() {
        
        var error = ""
        
        var pinCode = ""
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
        for i in 0..<tfs.count {
            if let tf = tfs[i] {
                if let text: String = tf.text {
                    if text.isEmpty {
                        tfs[i]?.becomeFirstResponder()
                        return
                    }
                    pinCode = "\(pinCode)\(text)"
                }
            }
        }
        
        if pinCode.length < 6 {
            error = "Bạn chưa điền đẩy đủ PIN Code"
        }
        
        
        if !error.isEmpty {
            let messageView = MessageView(frame: view.bounds)
            messageView.message = error
            addFullView(view: messageView)
        } else {
            
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            
            switch redeemType {
            case .gift:
                if let card = card, let shopID = card.shopID, let reward = reward, let rewardID = reward.rewardID {
                    if let code = NumberFormatter().number(from: pinCode) {
                        let redeemRequest = RedeemRequest(shopID: shopID, redeemID: rewardID, pinCode: code.intValue)
                        
                        weak var _self = self
                        
                        RedeemStore.redeemAward(redeemRequest: redeemRequest, completionHandler: { (success, error) in
                            if let _self = _self {
                                
                                loadingNotification.hide(animated: true)
                                
                                guard error == nil else {
                                    if let error = error as? ServerResponseError, let data = error.data {
                                        let messageView = MessageView(frame: _self.view.bounds)
                                        messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                        messageView.setButtonClose("Đóng", action: {
                                            if !AuthenticationStore().isLogin {
                                                HomeTabbarController.sharedInstance.logOut()
                                            }
                                        })
                                        _self.addFullView(view: messageView)
                                    }
                                    return
                                }
                                
                                if success {
                                    let popView = RedeemSuccessView(frame: _self.view.bounds)
                                    popView.delegate = self
                                    popView.card = card
                                    popView.reward = reward
                                    _self.addFullView(view: popView)
                                    
                                    if let successAction = _self.successAction {
                                        successAction()
                                    }
                                }
                            }
                        })
                    }
                }
                break
            case .voucher:
                
                if let voucher = voucher, let voucherID = voucher.voucherID {
                    let redeemRequest = RedeemRequest(pinCodeString: pinCode)
                    
                    weak var _self = self
                    
                    RedeemStore.redeemVoucher(voucherID: voucherID, redeemRequest: redeemRequest, completionHandler: { (success, error) in
                        if let _self = _self {
                            
                            loadingNotification.hide(animated: true)
                            
                            guard error == nil else {
                                if let error = error as? ServerResponseError, let data = error.data {
                                    let messageView = MessageView(frame: _self.view.bounds)
                                    messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                    messageView.setButtonClose("Đóng", action: {
                                        if !AuthenticationStore().isLogin {
                                            HomeTabbarController.sharedInstance.logOut()
                                        }
                                    })
                                    _self.addFullView(view: messageView)
                                }
                                return
                            }
                            
                            if success {
                                let popView = RedeemSuccessView(frame: _self.view.bounds)
                                popView.delegate = self
                                if let shop = voucher.shop {
                                    popView.card = Card(shop: shop)
                                }
                                popView.voucher = voucher
                                _self.addFullView(view: popView)
                                
                                if let successAction = _self.successAction {
                                    successAction()
                                }
                            }
                        }
                    })
                }
            case .deal:
                if let deal = deal, let dealID = deal.discoverID {
                    let redeemRequest = RedeemRequest(pinCodeString: pinCode)
                    
                    weak var _self = self
                    
                    RedeemStore.redeemDeal(dealID: dealID, redeemRequest: redeemRequest, completionHandler: { (success, error) in
                        if let _self = _self {
                            
                            loadingNotification.hide(animated: true)
                            
                            guard error == nil else {
                                if let error = error as? ServerResponseError, let data = error.data {
                                    let messageView = MessageView(frame: _self.view.bounds)
                                    messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                    messageView.setButtonClose("Đóng", action: {
                                        if !AuthenticationStore().isLogin {
                                            HomeTabbarController.sharedInstance.logOut()
                                        }
                                    })
                                    _self.addFullView(view: messageView)
                                }
                                return
                            }
                            
                            if success {
                                let popView = RedeemSuccessView(frame: _self.view.bounds)
                                popView.delegate = self
                                deal.isUsed = true
                                if let shop = deal.shop {
                                    popView.card = Card(shop: shop)
                                }
                                popView.deal = deal
                                _self.addFullView(view: popView)
                                
                                if let successAction = _self.successAction {
                                    successAction()
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        hideKeyboard()
    }
    
    @IBAction func buttonRedeemTapped(_ sender: AnyObject) {
        view.endEditing(true)
        sentRedeem()
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        constraintBottom.constant = keyboardRectangle.height
        view.setNeedsLayout()
        weak var _self = self
        UIView.animate(withDuration: 0.2) { 
            _self?.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        constraintBottom.constant = 0
        view.setNeedsLayout()
        weak var _self = self
        UIView.animate(withDuration: 0.2) {
            _self?.view.layoutIfNeeded()
        }
    }
}

extension RedeemViewController: RedeemSuccessViewDelegate {
    func buttonBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RedeemViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = string
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
        for i in 0..<tfs.count {
            if textField == tfs[i] {
                if string.isEmpty {
                    if (i - 1) >= 0 {
                        if let textF = tfs[i - 1] {
                            textF.becomeFirstResponder()
                            return false
                        }
                    }
                } else {
                    if (i + 1) < tfs.count {
                        if let textF = tfs[i + 1] {
                            textF.becomeFirstResponder()
                            return false
                        }
                    } else {
                        hideKeyboard()
                    }
                }
                break
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
        for tf in tfs {
            if let tf = tf {
                tf.layer.borderWidth = 0.5
            }
        }
    }
}
