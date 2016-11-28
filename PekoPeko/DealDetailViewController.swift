//
//  DealDetailViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

enum DealRowDisplayType: Int {
    case header = -10
    case time = -9
    case images = -8
    case price = -7
    case multiPrice = -6
    case control = -5
    case desc = -4
}

class DealDetailViewController: BaseViewController {

    static let storyboardName = "Discover"
    static let identify = "DealDetailViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var discoverID: String?
    
    var rowDisplayType: [Int] = [Int]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                var type: [Int] = [Int]()
                if discover.shop != nil {
                    type.append(DealRowDisplayType.header.rawValue)
                }
                
                type.append(DealRowDisplayType.time.rawValue)
                
                if discover.images != nil {
                    type.append(DealRowDisplayType.images.rawValue)
                }
                
                if let discoverType = discover.discoverType {
                    switch discoverType {
                    case .deal:
                        type.append(DealRowDisplayType.price.rawValue)
                    case .dealMulti:
                        type.append(DealRowDisplayType.multiPrice.rawValue)
                    }
                }
                
                type.append(DealRowDisplayType.control.rawValue)
                
                type.append(DealRowDisplayType.desc.rawValue)
                
                rowDisplayType = type
            }
        }
    }
    
    var successHandle: ((Discover?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: DiscoverShopDetailTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DiscoverShopDetailTableViewCell.identify)
        tableView.register(UINib(nibName: DealTimeTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealTimeTableViewCell.identify)
        tableView.register(UINib(nibName: DealImageTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealImageTableViewCell.identify)
        tableView.register(UINib(nibName: DealPriceTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealPriceTableViewCell.identify)
        tableView.register(UINib(nibName: DealMultiPriceTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealMultiPriceTableViewCell.identify)
        tableView.register(UINib(nibName: DealControlTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealControlTableViewCell.identify)
        tableView.register(UINib(nibName: DealDescriptionTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealDescriptionTableViewCell.identify)
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(DealDetailViewController.reloadDiscoverInfo), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if discover == nil {
            reloadDiscoverInfo()
        }
    }
    
    func reloadDiscoverInfo() {
        getDiscoverInfo()
    }
    
    func getDiscoverInfo() {
        if let discoverID = discoverID {
            
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            
            weak var _self = self
            DiscoverStore.getDealInfo(dealID: discoverID, completionHandler: { (discover, error) in
                if let _self = _self {
                    loadingNotification.hide(animated: true)
                    
                    if let refreshControl = _self.refreshControl {
                        refreshControl.endRefreshing()
                    }
                    
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: _self.view.bounds)
                            messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                            messageView.setButtonClose("Đóng", action: {
                                if !AuthenticationStore().isLogin {
                                    HomeTabbarController.sharedInstance.logOut()
                                }
                            })
                            _self.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if let discover = discover {
                        _self.discover = discover
                    }
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let successHandle = successHandle {
            successHandle(discover)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DealDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowDisplayType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = rowDisplayType[indexPath.row]
        
        switch cellType {
        case DealRowDisplayType.header.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverShopDetailTableViewCell.identify, for: indexPath) as! DiscoverShopDetailTableViewCell
            cell.discover = discover
            cell.delegate = self
            return cell
        case DealRowDisplayType.time.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: DealTimeTableViewCell.identify, for: indexPath) as! DealTimeTableViewCell
            cell.discover = discover
            return cell
        case DealRowDisplayType.images.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: DealImageTableViewCell.identify, for: indexPath) as! DealImageTableViewCell
            cell.discover = discover
            cell.delegate = self
            return cell
        case DealRowDisplayType.price.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: DealPriceTableViewCell.identify, for: indexPath) as! DealPriceTableViewCell
            cell.discover = discover
            return cell
        case DealRowDisplayType.multiPrice.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: DealMultiPriceTableViewCell.identify, for: indexPath) as! DealMultiPriceTableViewCell
            cell.discover = discover
            return cell
        case DealRowDisplayType.control.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: DealControlTableViewCell.identify, for: indexPath) as! DealControlTableViewCell
            cell.discover = discover
            cell.delegate = self
            return cell
        case DealRowDisplayType.desc.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: DealDescriptionTableViewCell.identify, for: indexPath) as! DealDescriptionTableViewCell
            cell.discover = discover
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

extension DealDetailViewController: DealImageTableViewCellDelegate {
    func imageTapped(image: UIImage?) {
        print("Show image")
    }
}

extension DealDetailViewController: DiscoverShopDetailTableViewCellDelegate {
    func telephoneTapped(shop: Shop?, telephone: String) {
        let alertView = AlertView(frame: view.bounds)
        alertView.message = telephone
        alertView.setButtonSubmit("Gọi", action: {
            if let url = URL(string: "tel://\(telephone)") {
                UIApplication.shared.openURL(url)
            }
        })
        addFullView(view: alertView)
    }
    
    func shopTapped(shop: Shop?){
        if let shop = shop {
            let card = Card(shop: shop)
            let shopDetailController = UIStoryboard(name: ShopDetailViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: ShopDetailViewController.identify) as! ShopDetailViewController
            shopDetailController.card = card
            present(shopDetailController, animated: true, completion: nil)
        }
    }
}

extension DealDetailViewController: DealControlTableViewCellDelegate {
    func saveDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void) {
        if let discover = discover, let dealID = discover.discoverID {
            if discover.isPayRequire {
                if !discover.isSave {
                    if !discover.isEnd {
                        let alertView = AlertView(frame: view.bounds)
                        alertView.message = "Deal này yêu cầu thanh toán trước"
                        alertView.setButtonSubmit("Thanh Toán", action: {
                            let payTypeViewController = UIStoryboard(name: PayTypeViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: PayTypeViewController.storyboardID) as! PayTypeViewController
                            payTypeViewController.targetID = dealID
                            payTypeViewController.delegate = self
                            if let topController = AppDelegate.topController() {
                                topController.present(payTypeViewController, animated: true, completion: nil)
                            }
                        })
                        addFullView(view: alertView)
                    }
                } else {
                    let messageView = MessageView(frame: view.bounds)
                    messageView.message = "Bạn đã trả trước cho Deal này, vui lòng tới cửa hàng để sử dụng"
                    addFullView(view: messageView)
                }
                
            } else {
                if discover.isSave {
                    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.indeterminate
                    weak var _self = self
                    DiscoverStore.unsaveDeal(dealID: dealID, completionHandler: { (success, error) in
                        if let _self = _self {
                            loadingNotification.hide(animated: true)
                            guard error == nil else {
                                if let error = error as? ServerResponseError, let data = error.data {
                                    let messageView = MessageView(frame: _self.view.bounds)
                                    messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                    messageView.setButtonClose("Đóng", action: {
                                        if !AuthenticationStore().isLogin {
                                            HomeTabbarController.sharedInstance.logOut()
                                        }
                                    })
                                    _self.addFullView(view: messageView)
                                }
                                return
                            }
                            
                            if success {
                                completionHandler(discover)
                            }
                        }
                    })
                } else {
                    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.indeterminate
                    weak var _self = self
                    DiscoverStore.saveDeal(dealID: dealID, completionHandler: { (success, error) in
                        if let _self = _self {
                            loadingNotification.hide(animated: true)
                            guard error == nil else {
                                if let error = error as? ServerResponseError, let data = error.data {
                                    let messageView = MessageView(frame: _self.view.bounds)
                                    messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                    messageView.setButtonClose("Đóng", action: {
                                        if !AuthenticationStore().isLogin {
                                            HomeTabbarController.sharedInstance.logOut()
                                        }
                                    })
                                    _self.addFullView(view: messageView)
                                }
                                return
                            }
                            
                            if success {
                                completionHandler(discover)
                            }
                        }
                    })
                }
            }
        }

    }
    
    func likeDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void) {
        if let discover = discover, let dealID = discover.discoverID {
            if discover.isLiked {
                let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                weak var _self = self
                DiscoverStore.unlikeDeal(dealID: dealID, completionHandler: { (success, error) in
                    if let _self = _self {
                        loadingNotification.hide(animated: true)
                        guard error == nil else {
                            if let error = error as? ServerResponseError, let data = error.data {
                                let messageView = MessageView(frame: _self.view.bounds)
                                messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                messageView.setButtonClose("Đóng", action: {
                                    if !AuthenticationStore().isLogin {
                                        HomeTabbarController.sharedInstance.logOut()
                                    }
                                })
                                _self.addFullView(view: messageView)
                            }
                            return
                        }
                        
                        if success {
                            completionHandler(discover)
                        }
                    }
                })
            } else {
                let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                weak var _self = self
                DiscoverStore.likeDeal(dealID: dealID, completionHandler: { (success, error) in
                    if let _self = _self {
                        loadingNotification.hide(animated: true)
                        guard error == nil else {
                            if let error = error as? ServerResponseError, let data = error.data {
                                let messageView = MessageView(frame: _self.view.bounds)
                                messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                messageView.setButtonClose("Đóng", action: {
                                    if !AuthenticationStore().isLogin {
                                        HomeTabbarController.sharedInstance.logOut()
                                    }
                                })
                                _self.addFullView(view: messageView)
                            }
                            return
                        }
                        
                        if success {
                            completionHandler(discover)
                        }
                    }
                })
            }
        }
    }
    
    func useDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void) {
        if let discover = discover {
            if discover.isNoPin {
                let messageView = MessageView(frame: view.bounds)
                messageView.message = "Để sử dụng vui lòng tới cửa hàng"
                addFullView(view: messageView)
            } else {
                let redeemViewController = UIStoryboard(name: RedeemViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: RedeemViewController.identify) as! RedeemViewController
                
                redeemViewController.deal = discover
                
                weak var _self = self
                redeemViewController.successHandle = {
                    
                    completionHandler(discover)
                    
                    if let _self = _self {
                        if let successHandle = _self.successHandle {
                            successHandle(discover)
                        }
                    }
                }
                
                if let topController = AppDelegate.topController() {
                    topController.present(redeemViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension DealDetailViewController: PayTypeViewControllerDelegate {
    func close(_ success: Bool) {
        if success {
            reloadDiscoverInfo()
        }
    }
}
