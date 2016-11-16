//
//  LoginPhoneViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Spring
import NVActivityIndicatorView
import CoreLocation

class LoginPhoneViewController: UIViewController {

    static let storyboardName = "Login"
    static let identify = "LoginPhoneViewController"
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewLogo: SpringImageView!
    @IBOutlet weak var buttonShowHidePassword: UIButton!
    @IBOutlet weak var buttonForgotPass: Button!
    
    @IBOutlet weak var labelIntro: Label!
    @IBOutlet weak var viewPhoneNumber: View!
    @IBOutlet weak var viewPassword: View!
    @IBOutlet weak var textfieldPhoneNumber: Textfield!
    @IBOutlet weak var textfieldPassword: Textfield!
    
    @IBOutlet weak var loginActivity: NVActivityIndicatorView!
    
    @IBOutlet weak var buttonSubmit: Button!
    
    let locationManager = CLLocationManager()
    var defaultConstraintValue: CGFloat?
    var userLocation: Location?
    
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
        if let top = DeviceConfig.getConstraintValue(d35: 20, d40: 50, d50: 50, d55: 50) {
            constraintTop.constant = top
        }
        defaultConstraintValue = constraintTop.constant
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        resetLabelIntro()
        loginActivity.stopAnimating()
        showLoginField()
        
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
        var error = ""
        var phoneNumber = ""
        var password = ""
        
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

        
        if error != "" {
            showError(error, animation: true)
        } else {
            slideDownView()
            hideLoginField()
            loginActivity.startAnimating()
            let loginParameter = LoginParameter(phone: phoneNumber, password: password, location: userLocation ?? Location(latitude: 0.0, longitude: 0.0))
            weak var _self = self
            AuthenticationStore.login(loginParameter, completionHandler: { (loginResponse, error) in
                
                
                guard error == nil else {
                    if let error = error as? ServerResponseError, let data = error.data,
                        let reason: String = data[NSLocalizedFailureReasonErrorKey] as? String {
                        _self?.showError(reason, animation: false)
                        _self?.loginActivity.stopAnimating()
                        _self?.showLoginField()
                    }
                    return
                }
                
                AuthenticationStore().savePhoneNumber(phoneNumber)
                
                if let loginResponse = loginResponse, let step = loginResponse.step {
                    if step == .verify {
                        let confirmCodeViewController = UIStoryboard(name: ConfirmCodeViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: ConfirmCodeViewController.identify) as! ConfirmCodeViewController
                        if let navigationController = _self?.navigationController {
                            navigationController.show(confirmCodeViewController, sender: nil)
                        }
                    }
                    
                    if step == .ready {
                        AuthenticationStore().saveLoginValue(true)
                        if let navigationController = _self?.navigationController {
                            navigationController.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                    if step == .update {
                        let confirmCodeViewController = UIStoryboard(name: UserUpdateInfoViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: UserUpdateInfoViewController.identify) as! UserUpdateInfoViewController
                        if let navigationController = _self?.navigationController {
                            navigationController.show(confirmCodeViewController, sender: nil)
                        }
                    }
                }
            })
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
    
    func hideLoginField() {
        let animation = "fadeOut"
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewPhoneNumber.animation = animation
        viewPhoneNumber.animate()
        
        viewPassword.animation = animation
        viewPassword.animate()
        
        buttonForgotPass.animation = animation
        buttonForgotPass.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
    
    func showLoginField() {
        let animation = "fadeInUp"
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewPhoneNumber.animation = animation
        viewPhoneNumber.animate()
        
        viewPassword.animation = animation
        viewPassword.animate()
        
        buttonForgotPass.animation = animation
        buttonForgotPass.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
}

extension LoginPhoneViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        userLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
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
        
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -110, d40: -90, d50: -65, d55: -65) {
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewPhoneNumber.layer.borderWidth = 0.5
        viewPassword.layer.borderWidth = 0.5
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
}
