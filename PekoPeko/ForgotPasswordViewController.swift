//
//  ForgotPasswordViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 28/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var textfieldOldPassword: UITextField!
    @IBOutlet weak var textfieldNewPassword: UITextField!
    @IBOutlet weak var textfieldRePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func buttonSaveTapped(_ sender: AnyObject) {
        var error = ""
        
        var oldPass = ""
        var newPass = ""
        
        if let text = textfieldOldPassword.text {
            if !text.isEmpty {
                oldPass = text
            } else {
                error = "Mật khẩu cũ không được để trống"
            }
        }
        
        if let text = textfieldNewPassword.text {
            if !text.isEmpty {
                if text.length >= 6 {
                    newPass = text
                } else {
                    error = "Mật khẩu mới không được ngắn hơn 6 kỹ tự"
                }
            } else {
                error = "Mật khẩu mới không được để trống"
            }
        }
        
        if let text = textfieldRePassword.text {
            if !text.isEmpty {
                if text != newPass {
                    error = "Xác nhận mật khẩu không đúng"
                }
            } else {
                error = "Xác nhận mật khẩu không được để trống"
            }
        }
        
        if !error.isEmpty {
            let messageView = MessageView(frame: view.bounds)
            messageView.message = error
            addFullView(view: messageView)
        } else {
            let user = User(currentPassword: oldPass, newPassword: newPass)
            weak var _self = self
            UserStore.uploadPassword(user, completionHandler: { (success, error) in
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
                    
                    if success {
                        let messageView = MessageView(frame: _self.view.bounds)
                        messageView.message = "Thay đổi thành công"
                        _self.addFullView(view: messageView)
                    }
                }
            })
        }
    }
}
