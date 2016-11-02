//
//  DiscoverListViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol DiscoverListViewControllerDelegate: class {
    func discoverTapped(discover: Discover?, completionHandler: @escaping () -> Void)
    func discoverUpdated()
}

class DiscoverListViewController: BaseViewController {
    
    static let storyboardName = "Discover"
    static let identify = "DiscoverListViewController"
    
    weak var delegate: DiscoverListViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var discovers = [Discover]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isNext: Bool = false
    var preID: [String]?
    var lastTime: Double?
    var isReload: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewConfig() {
        super.viewConfig()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: EmptyTableViewCell.identify, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.identify)
        tableView.register(UINib(nibName: DealTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealTableViewCell.identify)
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(DiscoverListViewController.reloadAllDiscover), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
    }
    
    func reloadAllDiscover() {
        isReload = true
        preID = nil
        lastTime = nil
        getAllDiscover()
    }
    
    func getAllDiscover() {
        let discoverRequest = DiscoverRequest(preID: preID, lastTime: lastTime)
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
                
                if _self.isReload {
                    _self.isReload = false
                    _self.discovers.removeAll()
                }
                
                if let discoverResponse = discoverResponse {
                    if let discovers = discoverResponse.discovers {
                        if discovers.count != 0 {
                            _self.discovers.append(contentsOf: discovers)
                            _self.isNext = true
                        } else {
                            _self.isNext = false
                        }
                    }
                }
                
                _self.tableView.tag = 0
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
        return discovers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealTableViewCell.identify, for: indexPath) as! DealTableViewCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        let discover = discovers[indexPath.row]
        cell.discover = discover
        cell.isLast = indexPath.row == (discovers.count - 1) ? true : false
        cell.delegate = self
        
        if isNext && self.tableView.tag == 0 && indexPath.row == discovers.count - 1 {
            
            preID = [discover.discoverID ?? ""]
            lastTime = discover.createdAt
            self.tableView.tag = 1
            getAllDiscover()
        }
        
        return cell
    }
}

extension DiscoverListViewController: DealTableViewCellDelegate {
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
                            _self.delegate?.discoverUpdated()
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
                            _self.delegate?.discoverUpdated()
                        }
                    }
                })
            }
        }
    }
    
    func discoverTapped(discover: Discover?, completionHandler: @escaping () -> Void) {
        delegate?.discoverTapped(discover: discover, completionHandler: { 
            completionHandler()
        })
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
                            _self.delegate?.discoverUpdated()
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
                            _self.delegate?.discoverUpdated()
                        }
                    }
                })
            }
        }
    }
}
