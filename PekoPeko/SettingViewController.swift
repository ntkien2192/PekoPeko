//
//  SettingViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 13/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Haneke
import FBSDKLoginKit

class SettingViewController: BaseViewController {

    @IBOutlet weak var constraintLogoutTop: NSLayoutConstraint!
    @IBOutlet weak var buttonChangePassword: Button!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonAvatar: Button!
    @IBOutlet weak var buttonTakePicture: Button!
    @IBOutlet weak var activityUploadData: NVActivityIndicatorView!
    @IBOutlet weak var buttonConnectFacebook: Button!
    
    @IBOutlet weak var labelAppVersion: UILabel!
    @IBOutlet weak var labelAppLanguage: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    
    var imagePicker: UIImagePickerController?
    
    var refreshControl: UIRefreshControl?
    
    var avatar: UIImage? {
        didSet {
            if let avatar = avatar {
                activityUploadData.color = UIColor.colorYellow
                activityUploadData.startAnimating()
                buttonTakePicture.isHidden = true
                buttonAvatar.isHidden = true
                weak var _self = self
                UserStore.updateAvatar(avatar, completionHandler: { (imageUrl, error) in
                    if let _self = _self {
                        _self.activityUploadData.stopAnimating()
                        _self.buttonTakePicture.isHidden = false
                        _self.buttonAvatar.isHidden = false
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
                        _self.buttonAvatar.setImage(url: imageUrl ?? "")
                    }
                })
            }
        }
    }
    
    var user: User? {
        didSet {
            if let user = user {
                if let fullName = user.fullName {
                    labelName.text = fullName
                }
                
                labelAppVersion.text = UIDevice().appVersion
                
                if let avatarUrl = user.avatarUrl {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: avatarUrl)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.buttonAvatar.setImage(image.cropToBounds(width: image.size.height, height: image.size.height), for: .normal)
                    })
                }
            }
        }
    }
    
    
    var isFacebookConnected: Bool = false {
        didSet {
            if isFacebookConnected {
                buttonConnectFacebook.setTitle("Đã kết nối với Facebook", for: .normal)
            } else {
                buttonConnectFacebook.setTitle("Kết nối với Facebook", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewConfig() {
        super.viewConfig()
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(SettingViewController.reloadUserInfo), for: .valueChanged)
            scrollView.addSubview(refreshControl)
            scrollView.sendSubview(toBack: refreshControl)
        }
        
        isFacebookConnected = AuthenticationStore().isFacebookConnected

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserInfo()
        getLoginType()
    }

    func reloadUserInfo() {
        getUserInfo()
    }
    
    func getLoginType() {
        if AuthenticationStore().isLoginWithPhone {
            buttonChangePassword.isHidden = false
            constraintLogoutTop.constant = 80.0
        } else {
            buttonChangePassword.isHidden = true
            constraintLogoutTop.constant = 15.0
        }
    }
    
    func getUserInfo() {
        weak var _self = self
        UserStore.getBaseUserInfo { (user, error) in
            if let _self = _self {
                if let refreshControl = _self.refreshControl {
                    refreshControl.endRefreshing()
                }
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
    
    @IBAction func buttonLogoutTapped(_ sender: AnyObject) {
        let alertView = AlertView(frame: view.bounds)
        alertView.message = "Xác nhận đăng xuất?"
        alertView.setButtonSubmit("Đăng xuất", action: {
            AuthenticationStore().saveLoginValue(false)
            let loginController = UIStoryboard(name: LoginViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identify)
            
            if let topController = AppDelegate.topController() {
                topController.present(loginController, animated: true, completion: nil)
            }
        })
        addFullView(view: alertView)
    }
    
    @IBAction func buttonConnectFacebookTapped(_ sender: AnyObject) {
        if !isFacebookConnected {
            let login = FBSDKLoginManager()
            login.logOut()
            weak var _self = self
            
            login.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (loginResult, error) -> Void in
                if let _self = _self {
                    guard error == nil else {
                        print("Process error")
                        return
                    }
                    
                    if let loginResult = loginResult {
                        if loginResult.isCancelled {
                            print("Cancelled")
                        } else {
                            
                            let token = FBSDKAccessToken.current().tokenString
                            
                            UserStore.connectFacebook(facebookCredential: token ?? "", completionHandler: { (success, error) in
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
                                    messageView.message = "Đã kết nối Facebook thành công"
                                    messageView.setButtonClose("Đóng", action: {
                                        if !AuthenticationStore().isLogin {
                                            HomeTabbarController.sharedInstance.logOut()
                                        }
                                    })
                                    _self.addFullView(view: messageView)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func buttonRateAppTapped(_ sender: AnyObject) {
        
    }
    
    @IBAction func buttonSendEmailTapped(_ sender: AnyObject) {
        
    }
    
    /// Take Pictures Alert Button
    ///
    /// - parameter sender: buttonAvatar / buttonTakePicture
    @IBAction func buttonTakePicturesTapped(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takeNewPictureAction = UIAlertAction(title: "Chụp ảnh mới", style: .default) { (action) in
            
            self.imagePicker = UIImagePickerController()
            
            if let imagePicker = self.imagePicker {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.allowsEditing = true
                
                imagePicker.navigationBar.backgroundColor = UIColor.colorYellow
                imagePicker.navigationBar.tintColor = UIColor.colorBrown
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.colorBrown]
                
                if let topController = AppDelegate.topController() {
                    topController.present(imagePicker, animated: true, completion: nil)
                }
            }
            
        }
        alertController.addAction(takeNewPictureAction)
        
        let choosePictureAction = UIAlertAction(title: "Chọn ảnh từ thư viện", style: .default) { (action) in
            self.imagePicker = UIImagePickerController()
            
            if let imagePicker = self.imagePicker {
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.navigationBar.backgroundColor = UIColor.colorYellow
                imagePicker.navigationBar.tintColor = UIColor.colorBrown
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.colorBrown]
                let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 20.0))
                view.backgroundColor = UIColor.colorYellow
                imagePicker.view.addSubview(view)
                imagePicker.view.bringSubview(toFront: view)
                view.translatesAutoresizingMaskIntoConstraints = false
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
                
                if let topController = AppDelegate.topController() {
                    topController.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        alertController.addAction(choosePictureAction)
        
        let cancleAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alertController.addAction(cancleAction)
        
        if let topController = AppDelegate.topController() {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension SettingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.avatar = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
