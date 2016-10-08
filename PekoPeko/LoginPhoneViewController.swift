//
//  LoginPhoneViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Spring
import MBProgressHUD
import NVActivityIndicatorView

class LoginPhoneViewController: UIViewController {

    // MARK: @IBOutlet
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewLogo: SpringImageView!
    @IBOutlet weak var buttonShowHidePassword: UIButton!
    
    @IBOutlet weak var labelIntro: Label!
    @IBOutlet weak var viewPhoneNumber: View!
    @IBOutlet weak var viewPassword: View!
    @IBOutlet weak var textfieldPhoneNumber: Textfield!
    @IBOutlet weak var textfieldPassword: Textfield!
    
    @IBOutlet weak var loginActivity: NVActivityIndicatorView!
    
    @IBOutlet weak var buttonSubmit: Button!
    
    var defaultConstraintValue: CGFloat?
    
    //MARK: View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewConfig()
    }
    
    func viewConfig() {
        defaultConstraintValue = constraintTop.constant
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: @IBAction
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonSubmitTapped(_ sender: AnyObject) {
        submit()
    }
    
    @IBAction func buttonShowHidePasswordTapped(_ sender: AnyObject) {
        textfieldPassword.isSecureTextEntry = !textfieldPassword.isSecureTextEntry
        textfieldPassword.becomeFirstResponder()
        textfieldPassword.contentHorizontalAlignment = .left
        textfieldPassword.contentVerticalAlignment = .center
        
        switch buttonShowHidePassword.tag {
        case 0:
            buttonShowHidePassword.tag = 1
            buttonShowHidePassword.tintColor = UIColor.colorOrange
            break
        case 1:
            buttonShowHidePassword.tag = 0
            buttonShowHidePassword.tintColor = UIColor.colorGray
            break
        default:
            break
        }
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        slideDownView()
    }
    
    func submit() {
        slideDownView()
        
        
//        let loadingView = MBProgressHUD.showAdded(to: view, animated: true)
//        loadingView.backgroundView.style = .solidColor
//        loadingView.backgroundView.color = UIColor.RGBA(0.0, green: 0.0, blue: 0.0, alpha: 0.3)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            loadingView.hide(animated: true)
//        }
        
        var error = ""
        var phoneNumber = ""
        var password = ""
        
        if error == "" {
            
        }
        
        if let phone = textfieldPhoneNumber.text {
            if !phone.isEmpty {
                phoneNumber = phone
            } else {
                error = "Số điện thoại không được để trống"
            }
        }
        
        if error == "" {
            if let pass = textfieldPassword.text {
                if !pass.isEmpty {
                    password = pass
                } else {
                    error = "Mật khẩu không được để trống"
                }
            }
        }

        
        if error != "" {
            showError(message: error, animation: true)
        } else {
            
            hideLoginField()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if phoneNumber == "1" && password == "1" {
                    self.login()
                } else {
                    self.showError(message: "Tài khoản này không tồn tại, vui lòng đăng nhập lại", animation: false)
                    self.showLoginField()
                }
            }
        }
    }
    
    func login() {
        if let navigationController = navigationController {
            AuthenticationStore().saveLoginValue(true)
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: View Model
    
    func resetLabelIntro() {
        labelIntro.text = "Vui lòng nhập số điện thoại & mật khẩu"
        labelIntro.backgroundColor = UIColor.clear
        labelIntro.textColor = UIColor.colorBrown
    }
    
    func showError(message: String, animation: Bool) {
        labelIntro.text = message
        labelIntro.backgroundColor = UIColor.colorBrown
        labelIntro.textColor = UIColor.white
        if animation {
            labelIntro.animation = "shake"
            labelIntro.duration = 0.5
            labelIntro.animate()
        }
    }
    
    func slideDownView() {
        view.endEditing(true)
        if let defaultConstraintValue = defaultConstraintValue {
            if constraintTop.constant != defaultConstraintValue {
                constraintTop.constant = defaultConstraintValue
                view.setNeedsLayout()
                imageViewLogo.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                    self.imageViewLogo.alpha = 1.0
                }
            }
        }
    }
    
    func hideLoginField() {
        let animation = "fadeOut"
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewPhoneNumber.animation = animation
        viewPhoneNumber.animate()
        
        viewPassword.animation = animation
        viewPassword.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
        
        loginActivity.startAnimating()
    }
    
    func showLoginField() {
        let animation = "fadeInUp"
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewPhoneNumber.animation = animation
        viewPhoneNumber.animate()
        
        viewPassword.animation = animation
        viewPassword.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
        
        loginActivity.stopAnimating()
    }
    

}

extension LoginPhoneViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            viewPhoneNumber.layer.borderWidth = 2.0
            break
        case 1:
            viewPassword.layer.borderWidth = 2.0
            break
        default:
            break
        }
        
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -40, d40: -90, d50: 0, d55: 0) {
            if constraintTop.constant != constraintValue {
                constraintTop.constant = constraintValue
                view.setNeedsLayout()
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.imageViewLogo.alpha = 0.0
                    }, completion: { _ in
                        self.imageViewLogo.isHidden = true
                })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewPhoneNumber.layer.borderWidth = 0.5
        viewPassword.layer.borderWidth = 0.5
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
}
