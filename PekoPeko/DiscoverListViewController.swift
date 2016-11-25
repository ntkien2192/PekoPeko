//
//  DiscoverListViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD
import DZNEmptyDataSet

protocol DiscoverListViewControllerDelegate: class {
    func discoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
    func discoverUpdated()
}

class DiscoverListViewController: BaseViewController {
    
    static let storyboardName = "Discover"
    static let identify = "DiscoverListViewController"
    
    weak var delegate: DiscoverListViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    var tableHeader: DealTableHeaderView?
    
    var discovers = [Discover]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var hotDeals = [Discover]() {
        didSet {
            if hotDeals.count != 0 {
                let width = view.bounds.width
                tableHeader = DealTableHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: width * 2.0 / 3.0))
                tableHeader?.delegate = self
                if let tableHeader = tableHeader {
                    tableHeader.deals = hotDeals
                    tableView.tableHeaderView = tableHeader
                }
            }
        }
    }
    
    var isNext: Bool = false
    var preID: [String]?
    var lastTime: Double?
    var isReload: Bool = false
    var isReloadList: Bool = false
    
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
        isReloadList = true
        preID = nil
        lastTime = nil
        getHotDeals()
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
                
                if _self.isReloadList {
                    _self.isReloadList = false
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
    
    func getHotDeals() {
        weak var _self = self
        DiscoverStore.getHotDeals { (discoverResponse, error) in
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
                    _self.hotDeals.removeAll()
                }
                
                if let discoverResponse = discoverResponse, let discovers = discoverResponse.discovers {
                    _self.hotDeals.append(contentsOf: discovers)
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
        
        let discover = discovers[indexPath.row]
        
        cell.discover = discover
        
        cell.isLast = indexPath.row == (discovers.count - 1) ? true : false
        cell.delegate = self
        
        if isNext && self.tableView.tag == 0 && indexPath.row == discovers.count - 1 {
            isNext = false
            tableView.tag = 1
            preID = [discover.discoverID ?? ""]
            lastTime = discover.createdAt
            getAllDiscover()
        }
        
        return cell
    }
}

extension DiscoverListViewController: DealTableViewCellDelegate, DealTableHeaderViewDelegate {
    func saveDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void) {
        if let discover = discover, let dealID = discover.discoverID {
            if discover.isPayRequire {
                let alertView = AlertView(frame: view.bounds)
                alertView.message = "Deal này yêu cầu thanh toán trước"
                alertView.setButtonSubmit("Thanh Toán", action: {
                    let payTypeViewController = UIStoryboard(name: PayTypeViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: PayTypeViewController.storyboardID) as! PayTypeViewController
                    payTypeViewController.targetID = dealID
                    
                    if let topController = AppDelegate.topController() {
                        topController.present(payTypeViewController, animated: true, completion: nil)
                    }
                })
                addFullView(view: alertView)
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
                                completionHandler(discover)
                                _self.delegate?.discoverUpdated()
                            }
                        }
                    })
                }
            }
        }
    }
    
    func discoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void) {
        delegate?.discoverTapped(discover: discover, completionHandler: { newDiscover in
            completionHandler(newDiscover)
        })
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
                            completionHandler(discover)
                            _self.delegate?.discoverUpdated()
                        }
                    }
                })
            }
        }
    }
}

extension DiscoverListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconBearEmpty")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(12), NSForegroundColorAttributeName: UIColor.colorGray]
        let variety1 = NSAttributedString(string: "Bạn có thể lưu các deal của\ncửa hàng để theo dõi!", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
}
