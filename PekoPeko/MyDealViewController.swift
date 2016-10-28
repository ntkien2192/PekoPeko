//
//  MyDealViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD
import DZNEmptyDataSet

protocol MyDealViewControllerDelegate: class {
    func discoverTapped(discover: Discover?)
}

class MyDealViewController: BaseViewController {
    
    static let storyboardName = "Discover"
    static let identify = "MyDealViewController"
    
    weak var delegate: MyDealViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var discovers: [Discover] = [Discover]() {
        didSet {
            for discover in discovers {
                discover.isSave = true
            }
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
        tableView.register(UINib(nibName: DealTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealTableViewCell.identify)
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(MyDealViewController.reloadMyDeal), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
    }
    
    func reloadMyDeal() {
        isReload = true
        preID = nil
        lastTime = nil
        getMyDeal()
    }
    
    func getMyDeal() {
        let discoverRequest = DiscoverRequest(preID: preID, lastTime: lastTime)
        weak var _self = self
        DiscoverStore.getMyDeal(discoverRequest: discoverRequest) { (discoverResponse, error) in
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

extension MyDealViewController: UITableViewDataSource {
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
            
            preID = [discover.discoverID ?? ""]
            lastTime = discover.savedAt
            self.tableView.tag = 1
            getMyDeal()
            
        }
        
        return cell
    }
}

extension MyDealViewController: DealTableViewCellDelegate {
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
        delegate?.discoverTapped(discover: discover)
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

extension MyDealViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconBearEmpty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(14), NSForegroundColorAttributeName: UIColor.darkGray]
        let variety1 = NSAttributedString(string: "Chưa có deal nào trong danh sách", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(12), NSForegroundColorAttributeName: UIColor.colorGray]
        let variety1 = NSAttributedString(string: "Bạn có thể lưu các deal của\ncửa hàng để theo dõi!", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
}
