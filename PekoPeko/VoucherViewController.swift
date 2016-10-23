//
//  VoucherViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class VoucherViewController: BaseViewController {

    static let storyboardName = "Voucher"
    static let identify = "VoucherViewController"
    
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var vouchers: [Voucher]? {
        didSet {
            if vouchers != nil {
                tableView.reloadData()
            }
        }
    }
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: VoucherTableViewCell.identify, bundle: nil), forCellReuseIdentifier: VoucherTableViewCell.identify)
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(VoucherViewController.reloadVoucher), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadVoucher()
    }
    
    func reloadVoucher() {
        getVoucher()
    }
    
    func getVoucher() {
        let voucherRequest = VoucherRequest()
         weak var _self = self
         VoucherStore.getAllVoucher(voucherRequest: voucherRequest) { (voucherResponse, error) in
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
                
                
                if let voucherResponse = voucherResponse {
                    if let vouchers = voucherResponse.vouchers {
                        _self.vouchers = vouchers
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension VoucherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let vouchers = vouchers {
            return vouchers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VoucherTableViewCell.identify, for: indexPath) as! VoucherTableViewCell
        if let vouchers = vouchers {
            cell.voucher = vouchers[indexPath.row]
        }
        return cell
    }
}

extension VoucherViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconGiftEmpty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(14), NSForegroundColorAttributeName: UIColor.darkGray]
        let variety1 = NSAttributedString(string: "Chưa có Voucher nào trong hệ thống", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(12), NSForegroundColorAttributeName: UIColor.colorGray]
        let variety1 = NSAttributedString(string: "Hãy mời thêm nhiều bạn mới để sử dụng\ncác món quà không giới hạn", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
}
