//
//  LoginUsernameViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 29/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class LoginUsernameViewController: UIViewController {

    static let storyboardName = "Login"
    static let storyboardID = "LoginUsernameViewController"
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewInput: View!
    @IBOutlet weak var labelMessage: Label!
    @IBOutlet weak var textfieldUserName: Textfield!
    @IBOutlet weak var textfieldPassword: Textfield!
    
    var defaultConstraintValue: CGFloat = DeviceConfig.getConstraintValue(d35: 20, d40: 70, d50: 50, d55: 50) ?? 0.0
    
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
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        submit()
    }

    @IBAction func buttonRegisterFacebookTapped(_ sender: Any) {
        
    }
    
    @IBAction func buttonRegisterGoogleTapped(_ sender: Any) {
        
    }
}


extension LoginUsernameViewController {
    //MARK: Function
    
    func keyboardWillShow(sender: NSNotification) {
        let textFields = [textfieldUserName, textfieldPassword]
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
    
    func submit() {
        hideKeyboard()
        
        var error: String?
        var authenticationRequest = AuthenticationRequest()
        
        if textfieldUserName.isEmpty() {
            error = error ?? "Tên đăng nhập không được để trống"
        } else {
            authenticationRequest.username = textfieldUserName.text
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
        
        if !(error ?? "").isEmpty {
            labelMessage.showError(error, animation: true)
        } else {
            register(authenticationRequest: authenticationRequest)
        }
        
    }
    
    func register(authenticationRequest: AuthenticationRequest) {
        
    }
    
}

extension LoginUsernameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFields = [textfieldUserName, textfieldPassword]
        for textF in textFields {
            if textField == textF {
                textF?.borderWidth = 2.0
            } else {
                textF?.borderWidth = 0.5
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textFields = [textfieldUserName, textfieldPassword]
        for textF in textFields {
            textF?.borderWidth = 0.5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfieldPassword {
            submit()
        }
        return true
    }
}
