//
//  AddPointViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import TSCurrencyTextField
import Haneke

protocol AddPointViewControllerDelegate: class {
    func pointAdded(point: Point?)
}

class AddPointViewController: BaseViewController {

    static let storyboardName = "Redeem"
    static let identify = "AddPointViewController"
    
    weak var delegate: AddPointViewControllerDelegate?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageView: ImageView!
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var textfieldCode1: Textfield!
    @IBOutlet weak var textfieldCode2: Textfield!
    @IBOutlet weak var textfieldCode3: Textfield!
    @IBOutlet weak var textfieldCode4: Textfield!
    @IBOutlet weak var textfieldCode5: Textfield!
    @IBOutlet weak var textfieldCode6: Textfield!
    
    @IBOutlet weak var buttonDiscount: UISwitch!
    @IBOutlet weak var textfieldMoney: TSCurrencyTextField!
    
    var defaultConstraintValue: CGFloat?
    
    var card: Card?
    var qrCode: QRCode?
    var address: Address?
    
    var isScan: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        textfieldMoney.rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textfieldMoney.rightViewMode = UITextFieldViewMode.always
        textfieldMoney.layer.cornerRadius = 5.0
        textfieldMoney.currencyNumberFormatter.locale = Locale.init(identifier: "en_VN")
        textfieldMoney.currencyNumberFormatter.currencySymbol = ""
        textfieldMoney.amount = NSNumber(value: 0.00)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
        if let defaultConstraintValue = defaultConstraintValue {
            if constraintTop.constant != defaultConstraintValue {
                constraintTop.constant = defaultConstraintValue
                view.setNeedsLayout()
                weak var _self = self
                UIView.animate(withDuration: 0.2) {
                    _self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultConstraintValue = constraintTop.constant
        if isScan {
            loadQRCode()
        } else {
            loadRewardInfo()
        }
        
    }
    
    func loadRewardInfo() {
        if !isScan {
            if let address = address {
                if let addressContent = address.addressContent {
                    labelAddress.text = addressContent
                }
            }
        }
        
        if let card = card {
            if let shopName = card.shopName {
                labelTitle.text = shopName
                labelName.text = shopName
            }
            
            
            if let shopAvatarUrl = card.shopAvatarUrl {
                let cache = Shared.imageCache
                let URL = NSURL(string: shopAvatarUrl)!
                let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                weak var _self = self
                _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                    _self?.imageView.image = image.cropToBounds(width: image.size.height, height: image.size.height)
                })
            }
            
            if isScan {
                if let addressList = card.addressList, let address = addressList.first {
                    if let addressContent = address.addressContent {
                        labelAddress.text = addressContent
                    }
                }
            }
        }
    }
    
    func loadQRCode() {
        if let qrCode = qrCode {
            if let shopID = qrCode.shopID, let addressID = qrCode.addressID {
                weak var _self = self
                ShopStore.getShopInfo(shopID: shopID, addressID: addressID, completionHandler: { (shop, error) in
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
                                self.view.addFullView(view: messageView)
                            }
                            return
                        }
                        
                        if let shop = shop {
                            _self.card = Card(shop: shop)
                            _self.loadRewardInfo()
                        }
                    }
                })
            }
        }
    }
    
    func addPoint() {
        var error = ""
        if textfieldMoney.amount.floatValue == 0.0 {
            error = "Số tiền tổng hoá đơn không được để trống"
        }
        
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
            messageView.setButtonClose("Đóng", action: {
                if !AuthenticationStore().isLogin {
                    HomeTabbarController.sharedInstance.logOut()
                }
            })
            self.view.addFullView(view: messageView)
        } else {
            
            var mainQrCode = QRCode()
            var mainPinCode = 0
            let mainBill = textfieldMoney.amount.doubleValue
            let mainHasDiscount = buttonDiscount.isOn
            
            if let address = address, let qrCode = address.qrCode {
                mainQrCode = qrCode
            }
            
            if let qrCode = qrCode {
                mainQrCode = qrCode
            }
            
            if let code = NumberFormatter().number(from: pinCode) {
                mainPinCode = code.intValue
            }
            
            redeemPoint(qrCode: mainQrCode, totalBill: mainBill, hasDiscount: mainHasDiscount, pinCode: mainPinCode)

        }

    }
    
    func redeemPoint(qrCode: QRCode, totalBill: Double, hasDiscount: Bool, pinCode: Int) {
        if let shopID = qrCode.shopID,
            let addressID = qrCode.addressID,
            let key = qrCode.key,
            let createdAt = qrCode.createdAt {
            
            
            let point = Point(shopID: shopID, addressID: addressID, pinCode: pinCode, key: key, pointType: 1, createdAt: createdAt, totalBill:totalBill, hasDiscount: hasDiscount)
            
            weak var _self = self
            
            RedeemStore.redeemPoint(point: point, completionHandler: { (point, error) in
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
                            _self.view.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if let point = point {
                        _self.dismiss(animated: true, completion: {
                            _self.delegate?.pointAdded(point: point)
                        })
                    }
                }
            })
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
    
    @IBAction func buttonAddPointTapped(_ sender: AnyObject) {
        addPoint()
    }
    
    @IBAction func buttonShopTapped(_ sender: AnyObject) {
        if let card = card {
            let shopDetailController = UIStoryboard(name: ShopDetailViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: ShopDetailViewController.identify) as! ShopDetailViewController
            shopDetailController.card = card
            present(shopDetailController, animated: true, completion: nil)
        }
    }
}

extension AddPointViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -40, d40: -200, d50: -65, d55: 0) {
            if constraintTop.constant != constraintValue {
                constraintTop.constant = constraintValue
                view.setNeedsLayout()
                weak var _self = self
                UIView.animate(withDuration: 0.2, animations: {
                    _self?.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = string
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
        for i in 0..<tfs.count {
            if textField == tfs[i] {
                if (i + 1) < tfs.count {
                    if let textF = tfs[i + 1] {
                        textF.becomeFirstResponder()
                        return false
                    }
                } else {
                    hideKeyboard()
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
