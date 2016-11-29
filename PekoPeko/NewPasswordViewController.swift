//
//  NewPasswordViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 01/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NewPasswordViewController: UIViewController {
    
    static let storyboardName = "Login"
    static let identify = "NewPasswordViewController"
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewLogo: ImageView!
    @IBOutlet weak var labelIntro: Label!
    @IBOutlet weak var viewConfirmCode: View!
    @IBOutlet weak var buttonSaveCode: Button!
    @IBOutlet weak var confirmActivity: NVActivityIndicatorView!
    @IBOutlet weak var labelWeb: Label!
    
    @IBOutlet weak var textfieldCode1: Textfield!
    @IBOutlet weak var textfieldCode2: Textfield!
    @IBOutlet weak var textfieldCode3: Textfield!
    @IBOutlet weak var textfieldCode4: Textfield!
    @IBOutlet weak var textfieldCode5: Textfield!
    @IBOutlet weak var textfieldCode6: Textfield!
    
    @IBOutlet weak var textfieldPassword: Textfield!
    @IBOutlet weak var viewTextfieldPassword: View!
    @IBOutlet weak var textfieldRePassword: Textfield!
    @IBOutlet weak var viewTextfieldRePassword: View!
    
    var defaultConstraintValue: CGFloat?
    
    var userLocation: Location?
    
    var loginType: String = "phone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewConfig()
    }
    
    func viewConfig() {
        if let top = DeviceConfig.getConstraintValue(d35: 20, d40: 50, d50: 50, d55: 50) {
            constraintTop.constant = top
        }
        defaultConstraintValue = constraintTop.constant
        
//        if let phone = AuthenticationStore().phoneNumber {
//            labelWeb.text = "Số của bạn: \(NSString(format: "%@", phone))"
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSaveTapped(_ sender: AnyObject) {
        confirm()
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        slideDownView()
    }
    
    func confirm() {
        
        var error = ""
        var code = ""
        var password = ""
        
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
        for i in 0..<tfs.count {
            if let tf = tfs[i] {
                if let text: String = tf.text {
                    if text.isEmpty {
                        tfs[i]?.becomeFirstResponder()
                        return
                    }
                    code = "\(code)\(text)"
                }
            }
        }
        
        if error.isEmpty {
            if let pass = textfieldPassword.text {
                if !pass.isEmpty {
                    if pass.length >= 6 {
                        password = pass
                    } else {
                        error = "Mật khẩu không được ngắn hơn 6 ký tự"
                    }
                } else {
                    error = "Mật khẩu không được để trống"
                }
            }
        }

        if error.isEmpty {
            if let rePass = textfieldRePassword.text {
                if rePass != password {
                    error = "Xác nhận mật khẩu không đúng"
                }
            }
        }
        
        if !error.isEmpty {
            showError(error, animation: true)
        } else {
            
            slideDownView()
            hideConfirmField()
            confirmActivity.startAnimating()
            
//            if AuthenticationStore().hasPhoneNumber {
//                if let phoneNumber = AuthenticationStore().phoneNumber {
//                    let loginParameter = LoginParameter(phone: phoneNumber, code: code, password: password)
//                    weak var _self = self
//                    
//                    AuthenticationStore.renewPassword(loginParameters: loginParameter, completionHandler: { (success, error) in
//                        if let _self = _self {
//                            _self.confirmActivity.stopAnimating()
//                            
//                            guard error == nil else {
//                                if let error = error as? ServerResponseError, let data = error.data,
//                                    let reason: String = data[NSLocalizedFailureReasonErrorKey] as? String {
//                                    _self.showError(reason, animation: false)
//                                    _self.showConfirmField()
//                                }
//                                return
//                            }
//                            
//                            if success {
//                                let messageView = MessageView(frame: _self.view.bounds)
//                                messageView.message = "Thay đổi mật khẩu thành công"
//                                messageView.setButtonClose("Đóng", action: {
//                                    if let navigationController = _self.navigationController {
//                                        navigationController.popToRootViewController(animated: true)
//                                    }
//                                })
//                                _self.addFullView(view: messageView)
//                            }
//                        }
//                    })
//                }
//            }
        }
    }
    
    //MARK: View Model
    
    func resetLabelIntro() {
        labelIntro.text = "Vui lòng nhập số điện thoại & mật khẩu"
        labelIntro.backgroundColor = UIColor.clear
        labelIntro.textColor = UIColor.colorBrown
    }
    
    func showError(_ message: String?, animation: Bool) {
        if let message = message {
            labelIntro.text = message
            labelIntro.backgroundColor = UIColor.colorBrown
            labelIntro.textColor = UIColor.white
            if animation {
                labelIntro.animation = "shake"
                labelIntro.duration = 0.5
                labelIntro.animate()
            }
        }
    }
    
    func slideDownView() {
        view.endEditing(true)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            labelWeb.isHidden = false
        }
        
        if let defaultConstraintValue = defaultConstraintValue {
            if constraintTop.constant != defaultConstraintValue {
                constraintTop.constant = defaultConstraintValue
                view.setNeedsLayout()
                imageViewLogo.isHidden = false
                weak var _self = self
                UIView.animate(withDuration: 0.2) {
                    _self?.view.layoutIfNeeded()
                    _self?.imageViewLogo.alpha = 1.0
                }
            }
        }
    }
    
    func hideConfirmField() {
        let animation = "fadeOut"
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewConfirmCode.animation = animation
        viewConfirmCode.animate()

        viewTextfieldPassword.animation = animation
        viewTextfieldPassword.animate()
        
        viewTextfieldRePassword.animation = animation
        viewTextfieldRePassword.animate()
        
        buttonSaveCode.animation = animation
        buttonSaveCode.animate()
    }
    
    func showConfirmField() {
        let animation = "fadeInUp"
        labelIntro.animation = animation
        labelIntro.animate()
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewConfirmCode.animation = animation
        viewConfirmCode.animate()
        
        viewTextfieldPassword.animation = animation
        viewTextfieldPassword.animate()
        
        viewTextfieldRePassword.animation = animation
        viewTextfieldRePassword.animate()
        
        buttonSaveCode.animation = animation
        buttonSaveCode.animate()
    }
}

extension NewPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            viewTextfieldPassword.layer.borderWidth = 2.0
            break
        case 1:
            viewTextfieldRePassword.layer.borderWidth = 2.0
            break
        default:
            textField.layer.borderWidth = 2.0
        }
        
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -130, d40: -70, d50: -50, d55: -50) {
            
            if DeviceType.IS_IPHONE_4_OR_LESS {
                labelWeb.isHidden = true
            }
            
            if constraintTop.constant != constraintValue {
                constraintTop.constant = constraintValue
                view.setNeedsLayout()
                weak var _self = self
                UIView.animate(withDuration: 0.2, animations: {
                    _self?.view.layoutIfNeeded()
                    _self?.imageViewLogo.alpha = 0.0
                    }, completion: { _ in
                        _self?.imageViewLogo.isHidden = true
                })
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != textfieldPassword && textField != textfieldRePassword {
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
                            if let text = textfieldPassword.text {
                                if text.isEmpty {
                                    textfieldPassword.becomeFirstResponder()
                                }
                            }
                            return false
                        }
                    }
                    break
                }
            }
        } else {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            viewTextfieldPassword.layer.borderWidth = 0.5
            break
        case 1:
            viewTextfieldRePassword.layer.borderWidth = 0.5
            break
        default:
            let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
            for tf in tfs {
                if let tf = tf {
                    tf.layer.borderWidth = 0.5
                }
            }
        }
    }
}
