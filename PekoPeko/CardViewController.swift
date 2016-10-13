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
    
    var storyList: CardListViewController?
    var myCardList: MyCardViewController?
    
    var currnetPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    func viewConfig() {
        storyList = UIStoryboard(name: CardListViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: CardListViewController.identify) as? CardListViewController
        
        myCardList = UIStoryboard(name: MyCardViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: MyCardViewController.identify) as? MyCardViewController

        if let storyList = storyList, let myCardList = myCardList {
            
            storyList.title = "Cửa hàng"
            storyList.delegate = self
            
            myCardList.title = "Thẻ của tôi"
            myCardList.delegate = self
            
            pageMenu = CAPSPageMenu(viewControllers: [storyList, myCardList], frame: view.bounds, pageMenuOptions: CAPSPageMenu.setting())
        }
        
        if let pageMenu = pageMenu {
            pageMenu.delegate = self
            pageMenu.view.backgroundColor = UIColor.RGB(230.0, green: 230.0, blue: 230.0)
            view.addSubview(pageMenu.view)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let pageMenu = pageMenu, let storyList = storyList, let myCardList = myCardList {
            switch pageMenu.currentPageIndex {
            case 0:
                storyList.reloadAllCard()
            case 1:
                myCardList.reloadMyCard()
            default:
                break
            }
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

}

extension CardViewController: CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if let pageMenu = pageMenu, let storyList = storyList, let myCardList = myCardList {
            if currnetPage != index {
                currnetPage = index
                switch pageMenu.currentPageIndex {
                case 0:
                    storyList.reloadAllCard()
                case 1:
                    myCardList.reloadMyCard()
                default:
                    break
                }
            }
        }
    }
}

extension CardViewController: CardListViewControllerDelegate, MyCardViewControllerDelegate{
    func buttonCardTapped(card: Card?) {
        present(card: card)
    }
}
