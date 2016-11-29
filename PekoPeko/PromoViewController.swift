//
//  PromoViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Spring
import Haneke

class PromoViewController: BaseViewController {
    
    static let storyboardName = "Home"
    static let identify = "PromoViewController"
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var labelPromoCode: Label!
    @IBOutlet weak var labelInviteNumber: Label!
    @IBOutlet weak var constraintLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewBear: SpringImageView!
    
    var user: User? {
        didSet {
            if let user = user {
                if let promoCode = user.promoCode {
                    self.promoCode = promoCode
                }
                
                if let invited = user.invited {
                    if invited == 0 {
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
                        let variety2 = NSAttributedString(string: "\(invited) người", attributes: attribute2)
                        attributedText.append(variety2)
                        
                        labelInviteNumber.attributedText = attributedText
                    }
                }
                
                if let rank = user.rank {
                    if let image = rank.image {
                        let cache = Shared.imageCache
                        let URL = NSURL(string: image)!
                        let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                        weak var _self = self
                        _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                            if let _self = _self {
                                _self.imageViewBear.image = image
                            }
                        })
                    }
                    
                    if let title = rank.name {
                        navigationItem.title = title
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

    override func viewConfig() {
        super.viewConfig()
        
        constraintLogoHeight.constant = DeviceConfig.getConstraintValue(d35: 80, d40: 110, d50: 110, d55: 110) ?? 110
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPromoCodeInfo()
    }
    
    func getPromoCodeInfo() {
        weak var _self = self
        UserStore.getPromoCodeInfo { (user, error) in
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
        if let user = user {
            let voucherViewController = UIStoryboard(name: VoucherViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: VoucherViewController.identify) as! VoucherViewController
            
            voucherViewController.user = user
            
            if let navigationController = navigationController {
                navigationController.show(voucherViewController, sender: nil)
            }
        }
    }
    
    @IBAction func buttonInviteTapped(_ sender: AnyObject) {
        let shareView = ShareView(frame: view.bounds)
        if let promoCode = promoCode {
            shareView.promoCode = promoCode
            shareView.delegate = self
        }
        addFullView(view: shareView)
    }
}

extension PromoViewController: ShareViewDelegate {
    func prompCodeTapped(promoCode: String?) {
        
        let text = "Tưng bừng ăn uống với vô vàn đồ ăn ngon cùng mình nhé. Nhập mã \(NSString(format: "%@", (promoCode ?? ""))) là có luôn vô vàn phiếu giảm giá đấy nha."
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        if let topController = AppDelegate.topController() {
            topController.present(activityViewController, animated: true, completion: nil)
        }
        
        
//        UIPasteboard.general.string = promoCode
//        let messageView = MessageView(frame: view.bounds)
//        messageView.message = "Đã sao chép mã vào bộ nhớ"
//        addFullView(view: messageView)
    }
    
    func facebookTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
    
    func googlePlusTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
    
    func mailTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
    
    func smsTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
}
