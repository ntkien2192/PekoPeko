//
//  LoginViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 07/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreLocation
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    static let storyboardName = "Login"
    static let identify = "LoginViewController"
    
    @IBOutlet weak var buttonFacebook: Button!
    @IBOutlet weak var buttonPhone: Button!
    @IBOutlet weak var loginActivity: NVActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var userLocation: Location?
    
    var isLoginSocial: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isLoginSocial {
            loginActivity.startAnimating()
        } else {
            viewAnimation()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewConfig()
    }
    
    func viewConfig() {
        UIApplication.shared.statusBarStyle = .default
        
        buttonFacebook.isHidden = true
        buttonPhone.isHidden = true
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func viewAnimation() {
        buttonFacebook.isHidden = false
        buttonFacebook.animation = "fadeInUp"
        buttonFacebook.duration = 0.5
        buttonFacebook.animate()
        
        buttonPhone.isHidden = false
        buttonPhone.animation = "fadeInUp"
        buttonPhone.duration = 0.5
        buttonPhone.animate()
    }
    
    @IBAction func buttonLoginTapped(_ sender: AnyObject) {
        let loginPhoneViewController = UIStoryboard(name: LoginPhoneViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: LoginPhoneViewController.identify) as! LoginPhoneViewController
        if let userLocation = userLocation {
            loginPhoneViewController.userLocation = userLocation
        }
        if let navigationController = navigationController {
            navigationController.show(loginPhoneViewController, sender: nil)
        }
    }
    
    @IBAction func buttonFacebookSigninClicked(sender: AnyObject) {
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
                        _self.isLoginSocial = true
                        
                        let token = FBSDKAccessToken.current().tokenString
                        
                        let loginParameter = LoginParameter(socialCredential: token ?? "", location: _self.userLocation ?? Location(latitude: 0.0, longitude: 0.0))
                        AuthenticationStore.loginSocial(loginParameter, completionHandler: { (loginResponse, error) in
                            
                            _self.isLoginSocial = false
                            _self.loginActivity.stopAnimating()
                            
                            
                            guard error == nil else {
                                if let error = error as? ServerResponseError, let data = error.data,
                                    let reason: String = data[NSLocalizedFailureReasonErrorKey] as? String {
                                    
                                    let messageView = MessageView(frame: _self.view.bounds)
                                    messageView.message = reason
                                    messageView.setButtonClose("Đóng", action: {
                                        if !AuthenticationStore().isLogin {
                                            HomeTabbarController.sharedInstance.logOut()
                                        }
                                    })
                                    _self.view.addFullView(view: messageView)
                                }
                                return
                            }
                            
                            if let loginResponse = loginResponse, let step = loginResponse.step {
                                if step == .input {
                                    let socialPhoneViewController = UIStoryboard(name: SocialConfirmViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: SocialConfirmViewController.identify) as! SocialConfirmViewController
                                    if let token = token{
                                        socialPhoneViewController.socialCredential = token
                                    }
                                    if let navigationController = _self.navigationController {
                                        navigationController.show(socialPhoneViewController, sender: nil)
                                    }
                                }
                                
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
                        })
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        userLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
