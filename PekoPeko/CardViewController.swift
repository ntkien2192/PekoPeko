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
        let storyList = UIStoryboard(name: CardListViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: CardListViewController.identify) as! CardListViewController
        storyList.title = "Cửa hàng"
        storyList.delegate = self
        
        let myCardList = UIStoryboard(name: MyCardViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: MyCardViewController.identify) as! MyCardViewController
        myCardList.title = "Thẻ của tôi"
        myCardList.delegate = self
        
        pageMenu = CAPSPageMenu(viewControllers: [storyList, myCardList], frame: view.bounds, pageMenuOptions: CAPSPageMenu.setting())
        if let pageMenu = pageMenu {
            pageMenu.view.backgroundColor = UIColor.RGB(230.0, green: 230.0, blue: 230.0)
            view.addSubview(pageMenu.view)
        }
    }

    func present(card: Card?) {
        if let card = card, let shopID = card.shopID {
            let cardDetailViewController = UIStoryboard(name: CardDetailViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: CardDetailViewController.identify) as! CardDetailViewController
            cardDetailViewController.cardID = shopID
            
            if let navigationController = navigationController {
                navigationController.show(cardDetailViewController, sender: nil)
            }
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

extension CardViewController: CardListViewControllerDelegate {
    func listCardTapped(card: Card?) {
        present(card: card)
    }
}

extension CardViewController: MyCardViewControllerDelegate {
    func myCardTapped(card: Card?) {
        present(card: card)
    }
}
