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
        if vouchers == nil {
            reloadVoucher()
        }
        
    }
    
    func reloadVoucher() {
        getVoucher()
        loadUserInfo()
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
    
    func loadUserInfo() {
        if let user = user {
            if (user.vouchers ?? 0) > 0 {
                labelInfo.text = "Bạn có thể sử dụng \((user.vouchers ?? 0)) phiếu giảm giá"
            } else {
                if (user.invited ?? 0) == 0 {
                    labelInfo.text = "Bạn cần mời ít nhất \((user.require ?? 0)) người để sử dụng các phiếu giám giá"
                } else {
                    labelInfo.text = "Bạn cần mời thêm \((user.require ?? 0) - (user.invited ?? 0)) người để sử dụng các phiếu giám giá"
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
            cell.delegate = self
        }
        return cell
    }
}

extension VoucherViewController: VoucherTableViewCellDelegate {
    func voucherTapped(voucher: Voucher?, completionHandler: @escaping (Bool) -> Void) {
        if let user = user {
            
            if (user.vouchers ?? 0) > 0 {
                let redeemViewController = UIStoryboard(name: RedeemViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: RedeemViewController.identify) as! RedeemViewController
                
                if let voucher = voucher {
                    redeemViewController.voucher = voucher
                }
                
                weak var _self = self
                redeemViewController.setSuccessHandle {
                    if let _self = _self, let user = _self.user {
                        if (user.vouchers ?? 0) - 1 >= 0 {
                            user.vouchers = (user.vouchers ?? 0) - 1
                            _self.loadUserInfo()
                            completionHandler(true)
                        }
                    }
                }
                
                if let topController = AppDelegate.topController() {
                    topController.present(redeemViewController, animated: true, completion: nil)
                }
            } else {
                weak var _self = self
                let alertView = AlertView(frame: view.bounds)
                alertView.message = "Bạn chưa mời đủ số người yêu cầu để sử dụng chức năng này."
                alertView.setButtonSubmit("Mời bạn", action: {
                    if let _self = _self {
                        let shareView = ShareView(frame: _self.view.bounds)
                        if let user = _self.user, let promoCode = user.promoCode {
                            shareView.promoCode = promoCode
                            shareView.delegate = self
                        }
                        _self.addFullView(view: shareView)
                    }
                })
                addFullView(view: alertView)
            }
        }
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

extension VoucherViewController: ShareViewDelegate {
    func prompCodeTapped(promoCode: String?) {
        UIPasteboard.general.string = promoCode
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Đã sao chép mã vào bộ nhớ"
        addFullView(view: messageView)
    }
    
    func facebookTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
    
    func googlePlusTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
    
    func mailTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
    
    func smsTapped(promoCode: String?) {
        let messageView = MessageView(frame: view.bounds)
        messageView.message = "Chức năng này đang được phát triển"
        addFullView(view: messageView)
    }
}
