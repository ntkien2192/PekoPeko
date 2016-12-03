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
import FBSDKShareKit
import MessageUI

class PromoViewController: BaseViewController {
    
    static let storyboardName = "Home"
    static let identify = "PromoViewController"
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var labelPromoCode: Label!
    @IBOutlet weak var labelInviteNumber: Label!
    @IBOutlet weak var constraintLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewBear: SpringImageView!
    
    let buttonShare = FBSDKShareButton()
    
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
        if let promoCode = promoCode {
            let shareView = ShareView(frame: view.bounds)
            shareView.promoCode = promoCode
            shareView.delegate = self
            addFullView(view: shareView)
        }
    }
}

extension PromoViewController: ShareViewDelegate {
    func prompCodeTapped(promoCode: String?) {
        let textToShare = [ "Tưng bừng ăn uống với vô vàn đồ ăn ngon cùng mình nhé. Nhập mã \(NSString(format: "%@", (promoCode ?? ""))) là có luôn vô vàn phiếu giảm giá đấy nha. Truy cập https://pekopeko.vn để biết thêm chi tiết" ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        if let topController = AppDelegate.topController() {
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func facebookTapped(promoCode: String?) {
        if !(promoCode ?? "").isEmpty {
            
            let promoCode = NSString(format: "%@", (promoCode ?? ""))
            
            UIPasteboard.general.string = "Tưng bừng ăn uống với vô vàn đồ ăn ngon cùng mình nhé. Nhập mã \(promoCode) là có luôn vô vàn phiếu giảm giá đấy nha. Truy cập https://pekopeko.vn để biết thêm chi tiết"
            
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = URL(string: "https://links.pekopeko.vn/?promo_code=\(promoCode)")
            content.contentTitle = "NHẬP MÃ \(promoCode) NGAY, NHẬN QUÀ LIỀN TAY"
            content.contentDescription = "Ví quà tặng hàng đầu Việt Nam"
            content.imageURL = URL(string: "https://files.pekopeko.vn/assets/general/iconpeko.png")
            
            buttonShare.shareContent = content
            buttonShare.center = view.center
            buttonShare.isHidden = true
            view.addSubview(buttonShare)
            view.sendSubview(toBack: buttonShare)
            
            buttonShare.sendActions(for: .touchUpInside)
        }
    }
    
    
    
    func mailTapped(promoCode: String?) {
        if !(promoCode ?? "").isEmpty {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                
                mail.mailComposeDelegate = self
                
                let promoCode = NSString(format: "%@", (promoCode ?? ""))
                
                mail.setMessageBody("Tưng bừng ăn uống với vô vàn đồ ăn ngon cùng mình nhé. Nhập mã <a href=\"https://links.pekopeko.vn/?promo_code=\(promoCode)\">\(promoCode)</a> là có luôn vô vàn phiếu giảm giá đấy nha. Truy cập <a href=\"https://pekopeko.vn\">https://pekopeko.vn</a> để biết thêm chi tiết", isHTML: true)
                
                present(mail, animated: true)
            } else {
                let messageView = MessageView(frame: view.bounds)
                messageView.message = "Chức năng này không thể sử dụng trên thiết bị của bạn"
                addFullView(view: messageView)
            }
        }

    }
    
    func smsTapped(promoCode: String?) {
        if !(promoCode ?? "").isEmpty{
            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                let promoCode = NSString(format: "%@", (promoCode ?? ""))
                
                controller.body = "Tưng bừng ăn uống với vô vàn đồ ăn ngon cùng mình nhé. Nhập mã \(promoCode) là có luôn vô vàn phiếu giảm giá đấy nha. Truy cập https://links.pekopeko.vn/?promo_code=\(promoCode) để đăng nhập nhé."
                controller.messageComposeDelegate = self
                present(controller, animated: true, completion: nil)
            } else {
                let messageView = MessageView(frame: view.bounds)
                messageView.message = "Chức năng này không thể sử dụng trên thiết bị của bạn"
                addFullView(view: messageView)
            }
        }
    }
}

extension PromoViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension PromoViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
