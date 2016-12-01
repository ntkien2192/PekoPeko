//
//  HomeTabbarController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 07/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class HomeTabbarController: UITabBarController {

    static let sharedInstance : HomeTabbarController = {
        let instance = HomeTabbarController()
        return instance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewConfig()
    }

    func viewConfig() {
        if let items = tabBar.items {
            for item in items {
                if let image = item.image {
                    item.image = image.withRenderingMode(.alwaysOriginal)
                }
                if let selectedImage = item.selectedImage {
                    item.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
                }
                item.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
            }
        }
        
        view.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !AuthenticationStore().isLogin {
//            logOut()world
        }
        view.isHidden = false
    }
    
    func logOut() {
//        let loginController = UIStoryboard(name: LoginViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identify)
//        if let topController = AppDelegate.topController() {
//            topController.present(loginController, animated: false, completion: nil)
//        }
    }
    
    func logOutIfNeeded() {
        if !AuthenticationStore().isLogin {
            let loginController = UIStoryboard(name: LoginViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identify)
            if let topController = AppDelegate.topController() {
                topController.present(loginController, animated: false, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
