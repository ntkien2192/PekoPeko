//
//  MyCardViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD
import DZNEmptyDataSet

protocol MyCardViewControllerDelegate: class {
    func buttonCardTapped(card: Card?)
}

class MyCardViewController: BaseViewController {

    static let storyboardName = "Card"
    static let identify = "MyCardViewController"
    
    weak var delegate: MyCardViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    var nextPage: String?
    
    var cards: [Card]? {
        didSet {
            if cards != nil {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewConfig() {
        tableView.register(UINib(nibName: MyCardTableViewCell.identify, bundle: nil), forCellReuseIdentifier: MyCardTableViewCell.identify)
        tableView.register(UINib(nibName: MyCardRewardTableViewCell.identify, bundle: nil), forCellReuseIdentifier: MyCardRewardTableViewCell.identify)
        
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(MyCardViewController.reloadMyCard), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
    }
    
    func reloadMyCard() {
        getMyCard()
    }
    
    func getMyCard() {
        let cardRequest = CardRequest(nextPage: nextPage ?? nil)
        weak var _self = self
        CardStore.getUserCard(cardRequest: cardRequest) { (cardResponse, error) in
            if let _self = _self {
                if let refreshControl = _self.refreshControl{
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
                        _self.view.addFullView(view: messageView)
                    }
                    return
                }
                
                if let cardResponse = cardResponse {
                    if let cards = cardResponse.cards {
                        _self.cards = cards
                    }
                    if let pagination = cardResponse.pagination, let nextPage = pagination.nextPage {
                        _self.nextPage = nextPage
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

extension MyCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cards = cards {
            return cards.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cards = cards {
            let card = cards[indexPath.row]
            if card.isReward() {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyCardRewardTableViewCell.identify, for: indexPath) as! MyCardRewardTableViewCell
                cell.delegate = self
                cell.card = card
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyCardTableViewCell.identify, for: indexPath) as! MyCardTableViewCell
                cell.delegate = self
                cell.card = card
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension MyCardViewController: MyCardTableViewCellDelegate, MyCardRewardTableViewCellDelegate {
    func cellTapped(card: Card?) {
        delegate?.buttonCardTapped(card: card)
    }
    
    func moreTapped(card: Card?) {
        weak var _self = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Xoá thẻ", style: .destructive) { (action) in
            if let _self = _self {
                let alertView = AlertView(frame: _self.view.bounds)
                alertView.message = "Xác nhận xoá thẻ?"
                alertView.setButtonSubmit("Xoá", action: {
                    let loadingNotification = MBProgressHUD.showAdded(to: _self.view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.indeterminate
                    if let card = card, let cardID = card.shopID {
                        CardStore.deleteCard(cardID: cardID, completionHandler: { (success, error) in
                            
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
                                    _self.view.addFullView(view: messageView)
                                }
                                return
                            }
                            
                            if success {
                                if let cards = _self.cards {
                                    var tempCard: [Card] = [Card]()
                                    for mainCard in cards {
                                        if let mainCardID = mainCard.shopID {
                                            if mainCardID != cardID {
                                                tempCard.append(mainCard)
                                            }
                                        }
                                    }
                                    _self.cards = tempCard
                                }
                            }
                        })
                    }
                })
                _self.view.addFullView(view: alertView)
            }
        }
        alertController.addAction(deleteAction)
        
        let cancleAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alertController.addAction(cancleAction)
        
        if let topController = AppDelegate.topController() {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension MyCardViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconBearEmpty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(14), NSForegroundColorAttributeName: UIColor.darkGray]
        let variety1 = NSAttributedString(string: "Chưa có thẻ nào trong danh sách", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(12), NSForegroundColorAttributeName: UIColor.colorGray]
        let variety1 = NSAttributedString(string: "Bạn có thể lưu các thẻ của\ncửa hàng để sử dụng!", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
}
