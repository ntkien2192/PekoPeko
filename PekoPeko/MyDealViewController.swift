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
    func discoverTapped(discover: Discover?, completionHandler: @escaping () -> Void)
    func myDiscoverUpdated()
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
        tableView.register(UINib(nibName: MyDealTableViewCell.identify, bundle: nil), forCellReuseIdentifier: MyDealTableViewCell.identify)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MyDealTableViewCell.identify, for: indexPath) as! MyDealTableViewCell
        
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

extension MyDealViewController: MyDealTableViewCellDelegate {

    func moreDiscoverTapped(discover: Discover?) {
        
        weak var _self = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Xoá Deal", style: .destructive) { (action) in
            if let _self = _self {
                let alertView = AlertView(frame: _self.view.bounds)
                alertView.message = "Xác nhận xoá Deal?"
                alertView.setButtonSubmit("Xoá", action: {
                    
                    if let discover = discover, let dealID = discover.discoverID {
                        let loadingNotification = MBProgressHUD.showAdded(to: _self.view, animated: true)
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
                                    var tempDiscover = [Discover]()
                                    for mainDiscover in _self.discovers {
                                        if let mainDiscoverID = mainDiscover.discoverID {
                                            if mainDiscoverID != dealID {
                                                tempDiscover.append(mainDiscover)
                                            }
                                        }
                                    }
                                    _self.discovers = tempDiscover
                                    _self.delegate?.myDiscoverUpdated()
                                }
                            }
                        })
                    }
                    
                })
                _self.addFullView(view: alertView)
            }
        }
        alertController.addAction(deleteAction)
        
        let cancleAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alertController.addAction(cancleAction)
        
        if let topController = AppDelegate.topController() {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func useDiscoverTapped(discover: Discover?, completionHandler: @escaping (Bool) -> Void) {
        if let discover = discover {
            if discover.isNoPin {
                let messageView = MessageView(frame: view.bounds)
                messageView.message = "Để sử dụng vui lòng tới cửa hàng"
                addFullView(view: messageView)
            } else {
                let redeemViewController = UIStoryboard(name: RedeemViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: RedeemViewController.identify) as! RedeemViewController
                redeemViewController.setSuccessHandle {
                    completionHandler(true)
                }
                redeemViewController.deal = discover
                if let topController = AppDelegate.topController() {
                    topController.present(redeemViewController, animated: true, completion: nil)
                }
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
                            _self.delegate?.myDiscoverUpdated()
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
                            _self.delegate?.myDiscoverUpdated()
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
        let variety1 = NSAttributedString(string: "Bạn có thể theo dõi các deal\n đã lưu tại đây!", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
}
