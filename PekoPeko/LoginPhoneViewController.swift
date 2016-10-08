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

class LoginPhoneViewController: UIViewController {

    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewLogo: SpringImageView!
    @IBOutlet weak var buttonShowHidePassword: UIButton!
    @IBOutlet weak var textfieldPhoneNumber: Textfield!
    @IBOutlet weak var textfieldPassword: Textfield!
    
    var defaultConstraintValue: CGFloat?
    
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
    
    func submit() {
        let loadingView = MBProgressHUD.showAdded(to: view, animated: true)
        loadingView.mode = MBProgressHUDMode.indeterminate
        loadingView.backgroundView.color = UIColor.RGBA(50, green: 50, blue: 50, alpha: 0.2)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginPhoneViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
}
