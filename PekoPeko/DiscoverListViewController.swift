//
//  DiscoverListViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class DiscoverListViewController: BaseViewController {
    
    static let storyboardName = "Discover"
    static let identify = "DiscoverListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var discovers: [Discover]? {
        didSet {
            if let discovers = discovers {
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
        
        tableView.register(UINib(nibName: DealMoreImageTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DealMoreImageTableViewCell.identify)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealMoreImageTableViewCell.identify, for: indexPath) as! DealMoreImageTableViewCell
        if let discovers = discovers {
            cell.discover = discovers[indexPath.row]
            
            
            cell.isLast = indexPath.row == 9 ? true : false
        }
        
        return cell
    }
}
