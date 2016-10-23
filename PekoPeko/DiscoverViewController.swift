//
//  DealListViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {

    static let storyboardName = "Home"
    static let identify = "DiscoverViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageMenu: CAPSPageMenu?
    
    var discoverList: DiscoverListViewController?
    var myDealList: MyDealViewController?
    
    var currnetPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let pageMenu = pageMenu, let discoverList = discoverList, let myDealList = myDealList {
            switch pageMenu.currentPageIndex {
            case 0:
                discoverList.reloadAllDiscover()
            case 1:
                //                    myCardList.reloadMyCard()
                break
            default:
                break
            }
        }
    }
    
    override func viewConfig() {
        super.viewConfig()
        
        discoverList = UIStoryboard(name: DiscoverListViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: DiscoverListViewController.identify) as? DiscoverListViewController
        
        myDealList = UIStoryboard(name: MyDealViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: MyDealViewController.identify) as? MyDealViewController
        
        if let discoverList = discoverList, let myDealList = myDealList {
            discoverList.title = "Khám phá"
//            discoverList.delegate = self
            
            myDealList.title = "Deal của tôi"
//            myDealList.delegate = self
            
            pageMenu = CAPSPageMenu(viewControllers: [discoverList, myDealList], frame: view.bounds, pageMenuOptions: CAPSPageMenu.setting())
        }
        
        if let pageMenu = pageMenu {
            pageMenu.delegate = self
            pageMenu.view.backgroundColor = UIColor.colorLightGray
            view.addSubview(pageMenu.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DiscoverViewController: CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if let pageMenu = pageMenu, let discoverList = discoverList, let myDealList = myDealList {
            if currnetPage != index {
                currnetPage = index
                switch pageMenu.currentPageIndex {
                case 0:
                    discoverList.reloadAllDiscover()
                case 1:
//                    myCardList.reloadMyCard()
                    break
                default:
                    break
                }
            }
        }
    }
}
