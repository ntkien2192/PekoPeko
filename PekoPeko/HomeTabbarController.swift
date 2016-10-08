//
//  HomeTabbarController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 07/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class HomeTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if !AuthenticationStore().isLogin {
            let loginController = UIStoryboard(name: LoginViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identify)
            
            if let navigationController = navigationController {
                navigationController.present(loginController, animated: false, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
