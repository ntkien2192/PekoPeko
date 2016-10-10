//
//  LoginViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 07/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    static let storyboardName = "Login"
    static let identify = "LoginViewController"
    
    @IBOutlet weak var buttonFacebook: Button!
    @IBOutlet weak var buttonPhone: Button!
    
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
        
        viewAnimation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewConfig()
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
    
    func viewConfig() {
        
        UIApplication.shared.statusBarStyle = .default
        
        buttonFacebook.isHidden = true
        buttonPhone.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
