//
//  UserUpdateInfoViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 10/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UserUpdateInfoViewController: UIViewController {

    static let storyboardName = "Login"
    static let identify = "UserUpdateInfoViewController"
    
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var activityUploadUserFullname: UIActivityIndicatorView!
    
    @IBOutlet weak var imageViewPromoCode: UIImageView!
    @IBOutlet weak var activityUploadPromoCode: UIActivityIndicatorView!
    
    
    @IBOutlet weak var buttonAvatar: Button!
    @IBOutlet weak var uploadAvatarActivity: NVActivityIndicatorView!
    @IBOutlet weak var buttonTakePicture: Button!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var buttonShowHidePassword: UIButton!
    @IBOutlet weak var viewInputName: View!
    @IBOutlet weak var viewInputCode: View!
    @IBOutlet weak var buttonSubmit: Button!
    @IBOutlet weak var labelIntro: Label!
    @IBOutlet weak var textfieldFullname: Textfield!
    @IBOutlet weak var textfieldPromoCode: Textfield!
    
    var defaultConstraintValue: CGFloat?
    
    var imagePicker: UIImagePickerController?
    var avatar: UIImage? {
        didSet {
            if let avatar = avatar {
                uploadAvatarActivity.startAnimating()
                buttonTakePicture.isHidden = true
                buttonAvatar.isHidden = true
                weak var _self = self
                UserStore.updateAvatar(avatar, completionHandler: { (imageUrl, error) in
                    if let _self = _self {
                        _self.uploadAvatarActivity.stopAnimating()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configView()
    }
    
    func configView() {
        defaultConstraintValue = constraintTop.constant
    }
    
    @IBAction func buttonStartTapped(_ sender: AnyObject) {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true, completion: nil)
        }
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
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        AuthenticationStore().saveLoginValue(true)
        if let navigationController = self.navigationController {
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        slideDownView()
    }
    
    func uploadFullname() {
        if let name = textfieldFullname.text {
            if !name.isEmpty {
                if let user = User(JSON: [UserFields.FullName.rawValue: name]) {
                    imageViewUser.isHidden = true
                    activityUploadUserFullname.startAnimating()
                    weak var _self = self
                    UserStore.uploadFullName(user, completionHandler: { (success, error) in
                        if let _self = _self {
                            _self.imageViewUser.isHidden = false
                            _self.activityUploadUserFullname.stopAnimating()
                            
                            guard error == nil else {
                                if let error = error as? ServerResponseError, let data = error.data,
                                    let reason: String = data[NSLocalizedFailureReasonErrorKey] as? String {
                                    _self.showError(reason, animation: false)
                                }
                                return
                            }
                        }
                        
                    })
                }
            }
        }
    }
    
    func uploadPromoCode() {
        if let code = textfieldPromoCode.text {
            if !code.isEmpty {
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let defaultConstraintValue = defaultConstraintValue {
            if constraintTop.constant != defaultConstraintValue {
                constraintTop.constant = defaultConstraintValue
                view.setNeedsLayout()
                buttonAvatar.isHidden = false
                buttonTakePicture.isHidden = false
                weak var _self = self
                UIView.animate(withDuration: 0.2) {
                    _self?.view.layoutIfNeeded()
                    _self?.buttonAvatar.alpha = 1.0
                    _self?.buttonTakePicture.alpha = 1.0
                }
            }
        }
    }
    
    func hideLoginField() {
        let animation = "fadeOut"
        
        viewInputName.animation = animation
        viewInputName.animate()
        
        viewInputCode.animation = animation
        viewInputCode.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
    
    func showLoginField() {
        let animation = "fadeInUp"
        
        viewInputName.animation = animation
        viewInputName.animate()
        
        viewInputCode.animation = animation
        viewInputCode.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
}

extension UserUpdateInfoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

extension UserUpdateInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            viewInputName.layer.borderWidth = 2.0
            break
        case 1:
            viewInputCode.layer.borderWidth = 2.0
            break
        default:
            break
        }
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -40, d40: -90, d50: -65, d55: 0) {
            if constraintTop.constant != constraintValue {
                constraintTop.constant = constraintValue
                view.setNeedsLayout()
                weak var _self = self
                UIView.animate(withDuration: 0.2, animations: {
                    _self?.view.layoutIfNeeded()
                    _self?.buttonAvatar.alpha = 0.0
                    _self?.buttonTakePicture.alpha = 0.0
                    }, completion: { _ in
                        _self?.buttonAvatar.isHidden = true
                        _self?.buttonTakePicture.isHidden = true
                })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewInputName.layer.borderWidth = 0.5
        viewInputCode.layer.borderWidth = 0.5
        
        switch textField.tag {
        case 0:
            uploadFullname()
            break
        case 1:
            uploadPromoCode()
            break
        default:
            break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            uploadFullname()
            break
        case 1:
            uploadPromoCode()
            break
        default:
            break
        }
        return true
    }
}
