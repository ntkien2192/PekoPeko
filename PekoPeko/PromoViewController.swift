//
//  PromoViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class PromoViewController: UIViewController {
    
    static let storyboardName = "Home"
    static let identify = "PromoViewController"
    
    @IBOutlet weak var labelPromoCode: Label!
    @IBOutlet weak var labelInviteNumber: Label!
    
    var user: User? {
        didSet {
            if let user = user {
                if let promoCode = user.promoCode {
                    self.promoCode = promoCode
                }
                
                if let point = user.points {
                    if point == 0 {
                        let attributedText = NSMutableAttributedString()
                        let attribute1 = [NSFontAttributeName: UIFont.getFont(16), NSForegroundColorAttributeName: UIColor.gray]
                        let variety1 = NSAttributedString(string: "Bạn chưa mời được người nào", attributes: attribute1)
                        attributedText.append(variety1)
                        
                        labelInviteNumber.attributedText = attributedText
                    } else {
                        let attributedText = NSMutableAttributedString()
                        let attribute1 = [NSFontAttributeName: UIFont.getFont(16), NSForegroundColorAttributeName: UIColor.gray]
                        let variety1 = NSAttributedString(string: "Bạn đã mời: ", attributes: attribute1)
                        attributedText.append(variety1)
                        
                        let attribute2 = [NSFontAttributeName: UIFont.getBoldFont(16), NSForegroundColorAttributeName: UIColor.colorOrange]
                        let variety2 = NSAttributedString(string: "\(point) người", attributes: attribute2)
                        attributedText.append(variety2)
                        
                        labelInviteNumber.attributedText = attributedText
                    }
                }
            }
        }
    }
    
    var promoCode: String? {
        didSet {
            if let promoCode = promoCode {
                labelPromoCode.text = promoCode
                labelPromoCode.animate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPromoCodeInfo()
    }
    
    func getPromoCodeInfo() {
        weak var _self = self
        UserStore.getBaseUserInfo { (user, error) in
            if let _self = _self {
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
                if let user = user {
                    _self.user = user
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonGiftTapped(_ sender: AnyObject) {
        let voucherViewController = UIStoryboard(name: VoucherViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: VoucherViewController.identify) as! VoucherViewController
        
        if let user = user {
            voucherViewController.user = user
        }
        
        if let navigationController = navigationController {
            navigationController.show(voucherViewController, sender: nil)
        }
    }
    
    @IBAction func buttonInviteTapped(_ sender: AnyObject) {
        let shareView = ShareView(frame: view.bounds)
        if let promoCode = promoCode {
            shareView.prompCode = promoCode
        }
        addFullView(view: shareView)
    }
}
