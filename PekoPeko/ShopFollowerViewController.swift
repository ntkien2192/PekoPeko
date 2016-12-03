//
//  ShopFollowerViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 03/12/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShopFollowerViewController: BaseViewController {

    static let storyboardName = "Shop"
    static let identify = "ShopFollowerViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var shopID: String?
    
    var nextPage = "0"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        
        tableView.register(UINib(nibName: ShopFollowerTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopFollowerTableViewCell.identify)
        
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(ShopFollowerViewController.reloadUser), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUser()
    }
    
    func reloadUser() {
        nextPage = "0"
        getUser()
    }
    
    func getUser() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        
        weak var _self = self
        if let shopID = shopID {
            ShopStore.getShopFollower(shopID: shopID, from: nextPage, completionHandler: { (userResponse, error) in
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
                    
                    if let userResponse = userResponse {
                        if let users = userResponse.users {
                            _self.users.append(contentsOf: users)
                            _self.tableView.reloadData()
                        }
                        
                        if let pagination = userResponse.pagination, let nextPage = pagination.nextPage {
                            _self.nextPage = nextPage
                        } else {
                            _self.nextPage = "NO"
                        }
                        
                        _self.tableView.tag = 0
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ShopFollowerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopFollowerTableViewCell.identify, for: indexPath) as! ShopFollowerTableViewCell
        cell.user = users[indexPath.row]
        
        
        if nextPage != "NO" && self.tableView.tag == 0 && indexPath.row == users.count - 1 {
            tableView.tag = 1
            getUser()
        }
        
        
        return cell
    }
}
