//
//  ProfileViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 30/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

enum ProfileCellType {
    case profileHeader
}

class ProfileViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cellTypes = [ProfileCellType]()
    
    var user: User? {
        didSet {
            if let user = user {
                cellTypes.append(.profileHeader)
                
                
                
                
                
                
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    
    override func viewConfig() {
        super.viewConfig()
        
        tableView.register(UINib(nibName: ProfileHeaderTableViewCell.identify, bundle: nil), forCellReuseIdentifier: ProfileHeaderTableViewCell.identify)
    }

}

extension ProfileViewController {
    func getUserInfo() {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        
        weak var _self = self
        
        UserStore.getUserInfo { (response, error) in
            if let _self = _self {
                
                loadingNotification.hide(animated: true)
                
                guard error == nil else {
                    if let error = error as? ServerResponseError, let data = error.data {
                        let messageView = MessageView(frame: _self.view.bounds)
                        messageView.set(content: data[NSLocalizedFailureReasonErrorKey] as! String?, buttonTitle: nil, action: { })
                        _self.addFullView(view: messageView)
                    }
                    return
                }
                

            }
        }
    }
    
    func loadViewInfo() {
        
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellTypes[indexPath.row] {
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderTableViewCell.identify, for: indexPath) as! ProfileHeaderTableViewCell
            
            
            return cell
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
