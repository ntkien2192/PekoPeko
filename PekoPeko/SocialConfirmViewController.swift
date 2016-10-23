//
//  FacebookConfirmViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 20/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Spring
import NVActivityIndicatorView
import CoreLocation

class SocialConfirmViewController: UIViewController {
    
    static let storyboardName = "Login"
    static let identify = "SocialConfirmViewController"
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewLogo: SpringImageView!
    
    @IBOutlet weak var labelIntro: Label!
    @IBOutlet weak var viewPhoneNumber: View!
    @IBOutlet weak var textfieldPhoneNumber: Textfield!
    
    @IBOutlet weak var loginActivity: NVActivityIndicatorView!
    
    @IBOutlet weak var buttonSubmit: Button!
    
    var defaultConstraintValue: CGFloat?
    
    let locationManager = CLLocationManager()
    var userLocation: Location?
    var socialCredential: String?
    
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
        if let top = DeviceConfig.getConstraintValue(d35: 40, d40: 50, d50: 50, d55: 50) {
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
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        slideDownView()
    }
    
    func submit() {
        var error = ""
        var phoneNumber = ""
        
        if let phone = textfieldPhoneNumber.text {
            if !phone.isEmpty {
                phoneNumber = phone
            } else {
                error = "Số điện thoại không được để trống"
            }
        }
        
        if error != "" {
            showError(error, animation: true)
        } else {
            slideDownView()
            hideLoginField()
            loginActivity.startAnimating()
            let loginParameter = LoginParameter(phone: phoneNumber, socialCredential: socialCredential ?? "", location: userLocation ?? Location(latitude: 0.0, longitude: 0.0))
            
            weak var _self = self
            AuthenticationStore.loginSocial(loginParameter, completionHandler: { (loginResponse, error) in
                if let _self = _self {
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data,
                            let reason: String = data[NSLocalizedFailureReasonErrorKey] as? String {
                            _self.showError(reason, animation: false)
                            _self.loginActivity.stopAnimating()
                            _self.showLoginField()
                        }
                        return
                    }
                    
                    AuthenticationStore().savePhoneNumber(phoneNumber)
                    
                    if let loginResponse = loginResponse, let step = loginResponse.step {
                        if step == .verify {
                            let confirmCodeViewController = UIStoryboard(name: ConfirmCodeViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: ConfirmCodeViewController.identify) as! ConfirmCodeViewController
                            confirmCodeViewController.loginType = "facebook"
                            if let navigationController = _self.navigationController {
                                navigationController.show(confirmCodeViewController, sender: nil)
                            }
                        }
                        
                        if step == .ready {
                            AuthenticationStore().saveLoginValue(true)
                            if let navigationController = _self.navigationController {
                                navigationController.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                        if step == .update {
                            let confirmCodeViewController = UIStoryboard(name: UserUpdateInfoViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: UserUpdateInfoViewController.identify)
                            if let navigationController = _self.navigationController {
                                navigationController.show(confirmCodeViewController, sender: nil)
                            }
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
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
    
    func showLoginField() {
        let animation = "fadeInUp"
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewPhoneNumber.animation = animation
        viewPhoneNumber.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
    
    
}

extension SocialConfirmViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        userLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

extension SocialConfirmViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            viewPhoneNumber.layer.borderWidth = 2.0
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
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
}
