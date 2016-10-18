//
//  ShopDetailViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 17/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

enum ShopRowDisplayType: Int {
    case header = -10
    case info = -9
    case address = -8
    case menuTitle = -7
    case moreMenu = -6
}

class MenuCellItem: NSObject {
    var menuItems: [MenuItem]?
    
    init(item: MenuItem) {
        self.menuItems = [item]
    }
    
    init(item1: MenuItem, item2: MenuItem) {
        self.menuItems = [item1, item2]
    }
    
    func count() -> Int {
        if let menuItems = menuItems {
            return menuItems.count
        }
        return 0
    }
}

class ShopDetailViewController: UIViewController {

    static let storyboardName = "Shop"
    static let identify = "ShopDetailViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var navigationView: UIView!
    
    var rowDisplayType: [Int] = [Int]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var card: Card?
    var shop: Shop? {
        didSet {
            if let shop = shop {
                var type: [Int] = [Int]()
                type.append(ShopRowDisplayType.header.rawValue)
                type.append(ShopRowDisplayType.info.rawValue)
                type.append(ShopRowDisplayType.address.rawValue)
                
                
                if let menuItems = shop.menuItems {
                    if menuItems.count != 0 {
                        
                        type.append(ShopRowDisplayType.menuTitle.rawValue)
                        
                        var tempMenuItems = [MenuItem]()
                        tempMenuItems.append(contentsOf: menuItems)
                        
                        var tempArr = [MenuCellItem]()
                        var index = 0
                        
                        if tempMenuItems.count > 1 {
                            let menuCellItem = MenuCellItem(item: tempMenuItems[0])
                            tempArr.append(menuCellItem)
                            tempMenuItems.remove(at: 0)
                            type.append(index)
                            index = index + 1
                        }
                        
                        if tempMenuItems.count > 1 {
                            if tempMenuItems.count % 2 == 0 {
                                for _ in 0..<Int(tempMenuItems.count / 2) {
                                    let menuCellItem = MenuCellItem(item1: tempMenuItems[0], item2: tempMenuItems[1])
                                    tempArr.append(menuCellItem)
                                    type.append(index)
                                    index = index + 1
                                    tempMenuItems.remove(at: 0)
                                    tempMenuItems.remove(at: 0)
                                }
                            } else {
                                for _ in 0..<Int(tempMenuItems.count / 2) {
                                    let menuCellItem = MenuCellItem(item1: tempMenuItems[0], item2: tempMenuItems[1])
                                    tempArr.append(menuCellItem)
                                    type.append(index)
                                    index = index + 1
                                    tempMenuItems.remove(at: 0)
                                    tempMenuItems.remove(at: 0)
                                }
                                
                                let menuCellItem = MenuCellItem(item: tempMenuItems[0])
                                tempArr.append(menuCellItem)
                                type.append(index)
                                tempMenuItems.remove(at: 0)
                            }
                        }
                        
                        type.append(ShopRowDisplayType.moreMenu.rawValue)
                        
                        self.menuItem = tempArr
                    }
                }
                
                self.rowDisplayType = type
            }
            
        }
    }
    
    var menuItem: [MenuCellItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewConfig()
    }

    func viewConfig() {
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: ShopCoverTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopCoverTableViewCell.identify)
        tableView.register(UINib(nibName: ShopInfoTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopInfoTableViewCell.identify)
        tableView.register(UINib(nibName: ShopAddressTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopAddressTableViewCell.identify)
        tableView.register(UINib(nibName: ShopMenuTitleTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopMenuTitleTableViewCell.identify)
        tableView.register(UINib(nibName: ShopMenuTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopMenuTableViewCell.identify)
        tableView.register(UINib(nibName: ShopMenu2TableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopMenu2TableViewCell.identify)
        tableView.register(UINib(nibName: ShopMenuShowMoreTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopMenuShowMoreTableViewCell.identify)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        getShopInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func getShopInfo() {
        if let card = card {
            if let shopID = card.shopID {
                weak var _self = self
                ShopStore.getShopFullInfo(shopID: shopID, completionHandler: { (shop, error) in
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: self.view.bounds)
                            messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                            self.view.addFullView(view: messageView)
                        }
                        return
                    }
                    if let shop = shop {
                        _self?.shop = shop
                    }
                })
            }
            
            if let shopName = card.shopName {
                labelTitle.text = shopName
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

extension ShopDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowDisplayType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = rowDisplayType[indexPath.row]
        
        switch cellType {
        case -10:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopCoverTableViewCell.identify, for: indexPath) as! ShopCoverTableViewCell
            cell.shop = shop
            return cell
        case -9:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopInfoTableViewCell.identify, for: indexPath) as! ShopInfoTableViewCell
            cell.delegate = self
            cell.shop = shop
            return cell
        case -8:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopAddressTableViewCell.identify, for: indexPath) as! ShopAddressTableViewCell
            cell.delegate = self
            cell.shop = shop
            return cell
        case -7:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopMenuTitleTableViewCell.identify, for: indexPath) as! ShopMenuTitleTableViewCell
            return cell
        case -6:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopMenuShowMoreTableViewCell.identify, for: indexPath) as! ShopMenuShowMoreTableViewCell
            cell.delegate = self
            return cell
        default:
            if let menuItem = menuItem {
                let menuCellItem = menuItem[cellType]
                
                if menuCellItem.count() == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ShopMenuTableViewCell.identify, for: indexPath) as! ShopMenuTableViewCell
                    cell.menuCellItem = menuCellItem
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ShopMenu2TableViewCell.identify, for: indexPath) as! ShopMenu2TableViewCell
                    cell.menuCellItem = menuCellItem
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}

extension ShopDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.y > 100.0 ? 100.0 : scrollView.contentOffset.y
        navigationView.alpha = value / 100.0
    }
}

extension ShopDetailViewController: ShopMenuShowMoreTableViewCellDelegate {
    func showMoreTapped() {
        let shopMenuViewController = UIStoryboard(name: ShopMenuViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: ShopMenuViewController.identify)
        
        present(shopMenuViewController, animated: true, completion: nil)
    }
}

extension ShopDetailViewController: ShopInfoTableViewCellDelegate {
    func followTapped(shop: Shop?, isFollowing: Bool) {
        if let shop = shop, let shopID = shop.shopID {
            if isFollowing {
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                UserStore.unFollow(followingID: shopID, completionHandler: { (success, error) in
                    loadingNotification.hide(animated: true)
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: self.view.bounds)
                            messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                            self.view.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if success {
                        shop.isFollowing = false
                        shop.followers = (shop.followers ?? 1) - 1
                        self.tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .automatic)
                    }
                })
            } else {
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                UserStore.follow(followingID: shopID, completionHandler: { (success, error) in
                    loadingNotification.hide(animated: true)
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: self.view.bounds)
                            messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                            self.view.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if success {
                        shop.isFollowing = true
                        shop.followers = (shop.followers ?? 0) + 1
                        self.tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .automatic)
                    }
                })
            }
        }
    }
}

extension ShopDetailViewController: ShopAddressTableViewCellDelegate, CardAddressViewDelegate {
    func telephoneTapped(shop: Shop?, telephone: String) {
        let alertView = AlertView(frame: self.view.bounds)
        alertView.message = telephone
        alertView.setButtonSubmit("Gọi", action: {
            if let url = URL(string: "tel://\(telephone)") {
                UIApplication.shared.openURL(url)
            }
        })
        view.addFullView(view: alertView)
    }
    
    func showMoreAddressTapped(shop: Shop?){
        if let shop = shop, let addresses = shop.addresses {
            let cardAddressView = CardAddressView(frame: view.bounds)
            cardAddressView.addresses = addresses
            cardAddressView.delegate = self
            self.view.addFullView(view: cardAddressView)
        }
    }
    
    func addressTapped(address: Address?) {
        if let address = address, let location = address.location {
            if let lat = location.latitude, let lon = location.longitude {
                
                let alertView = AlertView(frame: self.view.bounds)
                alertView.message = "Chuyển sang ứng dụng bản đồ"
                alertView.setButtonSubmit("Chuyển", action: {
                    if let url = URL(string: "http://maps.apple.com/?address=\(lat),\(lon)") {
                        UIApplication.shared.openURL(url)
                    }
                })
                view.addFullView(view: alertView)
            }
        }
    }
}
