//
//  LoginViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 07/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import MBProgressHUD

class LoginViewController: UIViewController {

    static let storyboardName = "Login"
    static let identify = "LoginViewController"
    
    
    @IBOutlet weak var imageView: SlideImage!
    @IBOutlet weak var viewButton: View!
    @IBOutlet weak var buttonRegister: Button!
    @IBOutlet weak var buttonLogin: Button!
    @IBOutlet weak var buttonFaceBook: View!
    @IBOutlet weak var buttonGoogle: View!
    
    
    let imageSlideData = [UIImage(named: "AppBackground1"), UIImage(named: "AppBackground2"), UIImage(named: "AppBackground3"), UIImage(named: "AppBackground4")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        imageView.setImage(data: imageSlideData as! [UIImage])
        
        viewAnimation(animation: "fadeInUp")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewConfig()
    }
    
    func viewConfig() {
        viewAnimation(animation: "fadeOut")
        UIApplication.shared.statusBarStyle = .default
    }
    
    func viewAnimation(animation: String) {
        viewButton.animation = animation
        viewButton.duration = 0.5
        viewButton.animate()
        
        buttonRegister.animation = animation
        buttonRegister.duration = 0.5
        buttonRegister.delay = 0.1
        buttonRegister.animate()

        buttonLogin.animation = animation
        buttonLogin.duration = 0.5
        buttonLogin.delay = 0.2
        buttonLogin.animate()
        
        buttonFaceBook.animation = animation
        buttonFaceBook.duration = 0.5
        buttonFaceBook.delay = 0.3
        buttonFaceBook.animate()
        
        buttonGoogle.animation = animation
        buttonGoogle.duration = 0.5
        buttonGoogle.delay = 0.3
        buttonGoogle.animate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ACTION
    
    @IBAction func buttonRegisterTapped(_ sender: Any) {
        let registerViewController = UIStoryboard(name: RegisterViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: RegisterViewController.storyboardID)
        navigationController?.show(registerViewController, sender: nil)
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        let loginUsernameViewController = UIStoryboard(name: LoginUsernameViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: LoginUsernameViewController.storyboardID)
        navigationController?.show(loginUsernameViewController, sender: nil)
    }
    
    @IBAction func buttonFackbookTapped(_ sender: Any) {
        loginFacebook()
    }
    
    @IBAction func buttonGoogleTapped(_ sender: Any) {
        
    }
}

extension LoginViewController {
    func loginFacebook() {
        let login = FBSDKLoginManager()
        weak var _self = self
        
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (loginResult, error) -> Void in
            if let _self = _self {
                guard error == nil else {
                    print("Process error")
                    return
                }
                
                if let loginResult = loginResult {
                    if !loginResult.isCancelled {
                        
                        let accessToken = FBSDKAccessToken.current().tokenString
                        _self.loginWithFacebook(accessToken: accessToken)
                        
                    }
                }
            }
        }
    }
    
    func loginWithFacebook(accessToken: String?) {
        if let accessToken = accessToken {
            let authenticationRequest = AuthenticationRequest(accessToken: accessToken)
            
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            
            weak var _self = self
            
            AuthenticationStore.loginWithFacebook(authenticationRequest: authenticationRequest, completionHandler: { (response, error) in
                if let _self = _self {
                    
                    loadingNotification.hide(animated: true)
                    
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: _self.view.bounds)
                            messageView.set(content: data[NSLocalizedFailureReasonErrorKey] as! String?, buttonTitle: nil, action: { })
                            _self.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if response != nil {
                        _self.loginSuccess()
                    }
                }
            })
        }
    }
    
    func loginSuccess() {
        
    }
}
