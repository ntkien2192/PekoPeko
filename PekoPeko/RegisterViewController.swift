//
//  RegisterViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 28/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UIViewController {

    static let storyboardName = "Login"
    static let storyboardID = "RegisterViewController"
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewInput: View!
    @IBOutlet weak var labelMessage: Label!
    @IBOutlet weak var textfieldUserName: Textfield!
    @IBOutlet weak var textfieldEmail: Textfield!
    @IBOutlet weak var textfieldName: Textfield!
    @IBOutlet weak var textfieldPassword: Textfield!
    @IBOutlet weak var textfieldREPassword: Textfield!
    
    var defaultConstraintValue: CGFloat = DeviceConfig.getConstraintValue(d35: 20, d40: 50, d50: 50, d55: 50) ?? 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configView()
    }
    
    func configView() {
        constraintTop.constant = defaultConstraintValue
        
        let views = [view, viewInput, viewTitle]
        for subView in views {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.hideKeyboard))
            subView?.addGestureRecognizer(tapGestureRecognizer)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ACTION

    @IBAction func buttonBackTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonRegisterTapped(_ sender: Any) {
        submit()
    }
    
}

extension RegisterViewController {
    //MARK: Animation
    func keyboardWillShow(sender: NSNotification) {
        let textFields = [textfieldUserName, textfieldEmail, textfieldName, textfieldPassword, textfieldREPassword]
        for textF in textFields {
            if textF?.isEditing ?? false {
                let moveConstraintValue = -(CGFloat((textF?.tag ?? 0)) * 50.0) + 70
                self.scrollView(moveConstraintValue: moveConstraintValue)
            }
        }
    }
    
    func scrollView(moveConstraintValue: CGFloat) {
        if constraintTop.constant != moveConstraintValue {
            constraintTop.constant = moveConstraintValue
            view.setNeedsLayout()
            weak var _self = self
            UIView.animate(withDuration: 0.2, animations: {
                _self?.view.layoutIfNeeded()
                _self?.viewTitle.alpha = 0.0
            }, completion: { _ in
                _self?.viewTitle.isHidden = true
            })
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
        slideDownView()
    }
    
    func slideDownView() {
        if constraintTop.constant != defaultConstraintValue {
            constraintTop.constant = defaultConstraintValue
            view.setNeedsLayout()
            viewTitle.isHidden = false
            weak var _self = self
            UIView.animate(withDuration: 0.2) {
                _self?.view.layoutIfNeeded()
                _self?.viewTitle.alpha = 1.0
            }
        }
    }
    
    //MARK: Controller
    func submit() {
        hideKeyboard()
        
        var error: String?
        var authenticationRequest = AuthenticationRequest()
        
        if textfieldUserName.isEmpty() {
            error = error ?? "Tên đăng nhập không được để trống"
        } else {
            authenticationRequest.username = textfieldUserName.text
        }
        
        if textfieldEmail.isEmpty() {
            error = error ?? "Email không được để trống"
        } else {
            if !(textfieldEmail.text ?? "").isEmail() {
                error = "Email sai định dạng"
            } else {
                authenticationRequest.email = textfieldEmail.text
            }
        }
        
        if textfieldName.isEmpty() {
            error = error ?? "Tên không được để trống"
        } else {
            authenticationRequest.fullName = textfieldName.text
        }
        
        if textfieldPassword.isEmpty() {
            error = error ?? "Mật khẩu không được để trống"
        } else {
            if !textfieldPassword.isContain(numBerOfCharacters: 8) {
                error = error ?? "Mật khẩu quá ngắn"
            } else {
                authenticationRequest.password = textfieldPassword.text
            }
            
        }
        
        if textfieldREPassword.isEmpty() {
            error = error ?? "Xác nhận mật khẩu không được để trống"
        } else {
            if textfieldREPassword.text != textfieldPassword.text {
                error = error ?? "Xác nhận mật khẩu không đúng"
            }
        }
        
        if !(error ?? "").isEmpty {
            labelMessage.showError(error, animation: true)
        } else {
            register(authenticationRequest: authenticationRequest)
        }
        
    }
    
    func register(authenticationRequest: AuthenticationRequest) {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        
        weak var _self = self
        AuthenticationStore.register(authenticationRequest: authenticationRequest, completionHandler: { (response, error) in
            if let _self = _self {
                loadingNotification.hide(animated: true)
                guard error == nil else {
                    if let error = error as? ServerResponseError, let data = error.data {
                        let messageView = MessageView(frame: _self.view.bounds)
                        messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                        _self.addFullView(view: messageView)
                    }
                    return
                }
                
                if response != nil {
                    _self.registerSuccess()
                }
            }
        })
    }
    
    func registerSuccess() {
        AuthenticationStore().saveLoginValue(true)
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFields = [textfieldUserName, textfieldEmail, textfieldName, textfieldPassword, textfieldREPassword]
        for textF in textFields {
            if textField == textF {
                textF?.borderWidth = 2.0
            } else {
                textF?.borderWidth = 0.5
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textFields = [textfieldUserName, textfieldEmail, textfieldName, textfieldPassword, textfieldREPassword]
        for textF in textFields {
             textF?.borderWidth = 0.5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfieldREPassword {
            submit()
        }
        return true
    }
}
