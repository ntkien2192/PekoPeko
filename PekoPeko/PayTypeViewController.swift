//
//  PayTypeViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

enum PayType: Int {
    case atm = 0
    case credit = 1
    case exchange = 2
}

protocol PayTypeViewControllerDelegate: class {
    func close(_ success: Bool)
}

class PayTypeViewController: UIViewController {

    static let storyboardName = "Redeem"
    static let storyboardID = "PayTypeViewController"
    
    weak var delegate: PayTypeViewControllerDelegate?
    
    @IBOutlet weak var viewATMCard: UIView!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewExchange: UIView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var labelMoney: UILabel!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    var targetID: String?
    
    var isLoaded = false
    
    var payType: PayType = .atm {
        didSet {
            var height = 0
            
            switch payType {
            case .atm:
                height = 50
                webView.loadHTMLString(atmMethod?.content ?? "", baseURL: nil)
            case .credit:
                height = 50
                webView.loadHTMLString(intMethod?.content ?? "", baseURL: nil)
            case .exchange:
                height = 0
                webView.loadHTMLString(transferMethod?.content ?? "", baseURL: nil)
            }
            
            if constraintHeight.constant != CGFloat(height) {
                constraintHeight.constant = CGFloat(height)
                view.setNeedsLayout()
                UIView.animate(withDuration: 0.2, animations: { 
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    var price: Float? {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "es_VN")
            formatter.currencySymbol = ""
            labelMoney.text = "\(formatter.string(from: NSNumber(value: (price ?? 0))) ?? "") VND"
        }
    }
    
    var atmMethod: PayMethod?
    var intMethod: PayMethod?
    var transferMethod: PayMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isLoaded {
            getPayData()
        }
    }
    
    func getPayData() {
        if let targetID = targetID {
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            
            weak var _self = self
            PayStore.getPayData(targetID: targetID, completionHandler: { (payResponse, error) in
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
                    
                    if let payResponse = payResponse {
                        _self.price = payResponse.price ?? 0
                        
                        if let atmMethod = payResponse.atmMethod {
                            _self.atmMethod = atmMethod
                        }
                        
                        if let intMethod = payResponse.intMethod {
                            _self.intMethod = intMethod
                        }
                        
                        if let transferMethod = payResponse.transferMethod {
                            _self.transferMethod = transferMethod
                        }
                        
                        _self.payType = .atm
                        _self.isLoaded = true
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonATMTapped(_ sender: Any) {
        payType = .atm
        loadTargetTypeView()
    }
    
    @IBAction func buttonCreditCard(_ sender: Any) {
        payType = .credit
        loadTargetTypeView()
    }
    
    @IBAction func buttonExchangeTapped(_ sender: Any) {
        payType = .exchange
        loadTargetTypeView()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadTargetTypeView() {
        let views = [viewATMCard, viewCreditCard, viewExchange]
        for i in 0..<views.count {
            if i == payType.rawValue {
                views[i]?.backgroundColor = UIColor.white
            } else {
                views[i]?.backgroundColor = UIColor.RGB(245, green: 245, blue: 245)
            }
        }
    }
    
    @IBAction func buttonPayTapped(_ sender: Any) {
        
        var url = ""
        
        switch payType {
        case .atm:
            if let atmMethod = atmMethod {
                url = atmMethod.payUrl ?? ""
            }
        case .credit:
            if let intMethod = intMethod {
                url = intMethod.payUrl ?? ""
            }
        default:
            break
        }
        
        let payViewController = UIStoryboard(name: PayViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: PayViewController.storyboardID) as! PayViewController
        payViewController.payUrl = url
        payViewController.delegate = self
        if let topController = AppDelegate.topController() {
            topController.present(payViewController, animated: true, completion: nil)
        }
    }
}

extension PayTypeViewController: PayViewControllerDelegate {
    func closeView(success: Bool) {
        if success {
            dismiss(animated: true, completion: { 
                self.delegate?.close(success)
            })
        }
    }
}
