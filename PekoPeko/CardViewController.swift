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
    var storyListNeedUpdate: Bool = false
    
    var myCardList: MyCardViewController?
    var myCardListNeedUpdate: Bool = false
    
    var currnetPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    func viewConfig() {
        storyList = UIStoryboard(name: CardListViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: CardListViewController.identify) as? CardListViewController
        
        myCardList = UIStoryboard(name: MyCardViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: MyCardViewController.identify) as? MyCardViewController

        if let storyList = storyList, let myCardList = myCardList {
            storyList.title = "Danh sách thẻ"
            storyList.delegate = self
            
            myCardList.title = "Thẻ của tôi"
            myCardList.delegate = self
            
            pageMenu = CAPSPageMenu(viewControllers: [storyList, myCardList], frame: view.bounds, pageMenuOptions: CAPSPageMenu.setting())
        }
        
        if let pageMenu = pageMenu {
            pageMenu.delegate = self
            pageMenu.view.backgroundColor = UIColor.colorLightGray
            view.addSubview(pageMenu.view)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let pageMenu = pageMenu, let storyList = storyList, let myCardList = myCardList {
            switch pageMenu.currentPageIndex {
            case 0:
                if storyList.cards.count == 0 || storyListNeedUpdate {
                    storyListNeedUpdate = false
                    storyList.reloadAllCard()
                } else {
                    storyList.reload()
                }
            case 1:
                if myCardList.cards.count == 0 || myCardListNeedUpdate {
                    myCardListNeedUpdate = false
                    myCardList.reloadMyCard()
                } else {
                    myCardList.reload()
                }
            default:
                break
            }
        }
    }
    
    func present(card: Card?) {
        if let card = card, let shopID = card.shopID {
            let cardDetailViewController = UIStoryboard(name: CardDetailViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: CardDetailViewController.identify) as! CardDetailViewController
            cardDetailViewController.cardID = shopID
            cardDetailViewController.delegate = self
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

extension CardViewController: CardDetailViewControllerDelegate {
    func cardUpdated() {
        myCardListNeedUpdate = true
    }
}

extension CardViewController: CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if let pageMenu = pageMenu, let storyList = storyList, let myCardList = myCardList {
            if currnetPage != index {
                currnetPage = index
                switch pageMenu.currentPageIndex {
                case 0:
                    if storyList.cards.count == 0 || storyListNeedUpdate {
                        storyListNeedUpdate = false
                        storyList.reloadAllCard()
                    } else {
                        storyList.reload()
                    }
                case 1:
                    if myCardList.cards.count == 0 || myCardListNeedUpdate {
                        myCardListNeedUpdate = false
                        myCardList.reloadMyCard()
                    } else {
                        myCardList.reload()
                    }
                default:
                    break
                }
            }
        }
    }
}

extension CardViewController: CardListViewControllerDelegate, MyCardViewControllerDelegate {
    func buttonCardTapped(card: Card?) {
        present(card: card)
    }
}
