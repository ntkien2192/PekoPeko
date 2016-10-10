//
//  CardViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
    }
    
    func viewConfig() {
        let storyList = UIStoryboard(name: StoreListViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: StoreListViewController.identify) as! StoreListViewController
        storyList.title = "Cửa hàng"
        
        let myCardList = UIStoryboard(name: MyCardViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: MyCardViewController.identify) as! MyCardViewController
        myCardList.title = "Thẻ của tôi"
        
        pageMenu = CAPSPageMenu(viewControllers: [storyList, myCardList], frame: view.bounds, pageMenuOptions: CAPSPageMenu.setting())
        if let pageMenu = pageMenu {
            view.addSubview(pageMenu.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonLogoutTapped(_ sender: AnyObject) {
        AuthenticationStore().saveLoginValue(false)
        let loginController = UIStoryboard(name: LoginViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identify)
        if let navigationController = navigationController {
            navigationController.present(loginController, animated: false, completion: nil)
        }
    }
}
