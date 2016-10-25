//
//  DiscoverListViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

class DiscoverListViewController: BaseViewController {
    
    static let storyboardName = "Discover"
    static let identify = "DiscoverListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var discovers: [Discover]? {
        didSet {
            if discovers != nil {
                 tableView.reloadData()
            }
        }
    }
    
    var nextPage: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewConfig() {
        super.viewConfig()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: EmptyTableViewCell.identify, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.identify)
        tableView.register(UINib(nibName: Deal1ImageTableViewCell.identify, bundle: nil), forCellReuseIdentifier: Deal1ImageTableViewCell.identify)
        tableView.register(UINib(nibName: Deal2ImageTableViewCell.identify, bundle: nil), forCellReuseIdentifier: Deal2ImageTableViewCell.identify)
        tableView.register(UINib(nibName: Deal3ImageTableViewCell.identify, bundle: nil), forCellReuseIdentifier: Deal3ImageTableViewCell.identify)
        tableView.register(UINib(nibName: DealMoreImageTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealMoreImageTableViewCell.identify)
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(DiscoverListViewController.reloadAllDiscover), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
    }
    
    func reloadAllDiscover() {
        nextPage = "0"
        getAllDiscover()
    }
    
    func getAllDiscover() {
        let discoverRequest = DiscoverRequest(preID: nil, lastTime: nil)
        weak var _self = self
        DiscoverStore.getAllDiscover(discoverRequest: discoverRequest) { (discoverResponse, error) in
            if let _self = _self {
                
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
                
                if let discoverResponse = discoverResponse {
                    if let discovers = discoverResponse.discovers {
                        _self.discovers = discovers
                    }
//                    if let pagination = cardResponse.pagination, let nextPage = pagination.nextPage {
//                        _self.nextPage = nextPage
//                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DiscoverListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let discovers = discovers {
            return discovers.count
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let discovers = discovers {
            let discover = discovers[indexPath.row]
            switch discover.imageCount() {
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: Deal1ImageTableViewCell.identify, for: indexPath) as! Deal1ImageTableViewCell
                cell.discover = discover
                cell.isLast = indexPath.row == (discovers.count - 1) ? true : false
                cell.delegate = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: Deal2ImageTableViewCell.identify, for: indexPath) as! Deal2ImageTableViewCell
                cell.discover = discover
                cell.isLast = indexPath.row == (discovers.count - 1) ? true : false
                
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: Deal3ImageTableViewCell.identify, for: indexPath) as! Deal3ImageTableViewCell
                cell.discover = discover
                cell.isLast = indexPath.row == (discovers.count - 1) ? true : false
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: DealMoreImageTableViewCell.identify, for: indexPath) as! DealMoreImageTableViewCell
                cell.discover = discover
                cell.isLast = indexPath.row == (discovers.count - 1) ? true : false
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identify, for: indexPath) as! EmptyTableViewCell
        return cell
    }
}

extension DiscoverListViewController: Deal1ImageTableViewCellDelegate {
    func shareDiscoverTapped(discover: Discover?) {
        
    }
    
    func saveDiscoverTapped(discover: Discover?, isSaved: Bool, completionHandler: @escaping (Bool) -> Void) {
        if let discover = discover, let dealID = discover.discoverID {
            if isSaved {
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
                            completionHandler(true)
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
                            completionHandler(true)
                        }
                    }
                })
            }
        }
    }
    
    func discoverTapped(discover: Discover?) {
        
    }
    
    func likeDiscoverTapped(discover: Discover?, isLiked: Bool, completionHandler: @escaping (Bool) -> Void) {
        if let discover = discover, let dealID = discover.discoverID {
            if isLiked {
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
                            completionHandler(true)
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
                            completionHandler(true)
                        }
                    }
                })
            }
        }
    }
}
