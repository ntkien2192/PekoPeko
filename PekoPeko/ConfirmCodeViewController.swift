//
//  ConfirmCodeViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 10/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreLocation

class ConfirmCodeViewController: UIViewController {

    static let storyboardName = "Login"
    static let identify = "ConfirmCodeViewController"
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewLogo: ImageView!
    @IBOutlet weak var labelIntro: Label!
    @IBOutlet weak var viewConfirmCode: View!
    @IBOutlet weak var buttonResetCode: Button!
    @IBOutlet weak var confirmActivity: NVActivityIndicatorView!
    
    
    @IBOutlet weak var textfieldCode1: Textfield!
    @IBOutlet weak var textfieldCode2: Textfield!
    @IBOutlet weak var textfieldCode3: Textfield!
    @IBOutlet weak var textfieldCode4: Textfield!
    
    var defaultConstraintValue: CGFloat?
    
    let locationManager = CLLocationManager()
    var userLocation: Location?
    
    var loginType: String = "phone"
    
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
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        slideDownView()
    }
    
    func confirm() {
        slideDownView()
        hideConfirmField()
        confirmActivity.startAnimating()
        
        var code = ""
        
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4]
        for i in 0..<tfs.count {
            if let tf = tfs[i] {
                if let text: String = tf.text {
                    if text.isEmpty {
                        tfs[i]?.becomeFirstResponder()
                        return
                    }
                    code = "\(code)\(text)"
                }
            }
        }
        
        if AuthenticationStore().hasPhoneNumber {
            if let phoneNumber = AuthenticationStore().phoneNumber {
                let loginParameter = LoginParameter(phone: phoneNumber, code: code, type: loginType, location: userLocation ?? Location(latitude: 0.0, longitude: 0.0))
                weak var _self = self
                AuthenticationStore.confirm(loginParameter, completionHandler: { (loginResponse, error) in
                    
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data,
                            let reason: String = data[NSLocalizedFailureReasonErrorKey] as? String {
                            _self?.showError(reason, animation: false)
                            _self?.confirmActivity.stopAnimating()
                            _self?.showConfirmField()
                        }
                        return
                    }
                    
                    if let loginResponse = loginResponse, let step = loginResponse.step {
                        if step == .ready {
                            AuthenticationStore().saveLoginValue(true)
                            if let navigationController = _self?.navigationController {
                                navigationController.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                        if step == .update {
                            let confirmCodeViewController = UIStoryboard(name: UserUpdateInfoViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: UserUpdateInfoViewController.identify)
                            if let navigationController = _self?.navigationController {
                                navigationController.show(confirmCodeViewController, sender: nil)
                            }
                        }
                    }
                })
            }
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
    
    func hideConfirmField() {
        let animation = "fadeOut"
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewConfirmCode.animation = animation
        viewConfirmCode.animate()
        
        buttonResetCode.animation = animation
        buttonResetCode.animate()
    }
    
    func showConfirmField() {
        let animation = "fadeInUp"
        labelIntro.animation = animation
        labelIntro.animate()
        
        labelIntro.animation = animation
        labelIntro.animate()
        
        viewConfirmCode.animation = animation
        viewConfirmCode.animate()
        
        buttonResetCode.animation = animation
        buttonResetCode.animate()
    }
}

extension ConfirmCodeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        userLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

extension ConfirmCodeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
        
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -40, d40: -90, d50: -50, d55: -50) {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = string
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4]
        for i in 0..<tfs.count {
            if textField == tfs[i] {
                if (i + 1) < tfs.count {
                    if let textF = tfs[i + 1] {
                        textF.becomeFirstResponder()
                        return false
                    }
                } else {
                    self.confirm()
                }
                break
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4]
        for tf in tfs {
            if let tf = tf {
                tf.layer.borderWidth = 0.5
            }
        }
    }
}
