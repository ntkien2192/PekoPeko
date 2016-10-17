//
//  MyCardViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        tableView.tableFooterView = UIView()
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
            if let refreshControl = _self?.refreshControl{
                refreshControl.endRefreshing()
            }
            guard error == nil else {
                if let error = error as? ServerResponseError, let data = error.data {
                    let messageView = MessageView(frame: self.view.bounds)
                    messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                    self.view.addFullView(view: messageView)
                }
                return
            }
            
            if let cardResponse = cardResponse {
                if let cards = cardResponse.cards {
                    _self?.cards = cards
                }
                if let pagination = cardResponse.pagination, let nextPage = pagination.nextPage {
                    _self?.nextPage = nextPage
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCardTableViewCell.identify, for: indexPath) as! MyCardTableViewCell
        
        if let cards = cards {
            cell.delegate = self
            cell.card = cards[indexPath.row]
        }
        return cell
    }
}

extension MyCardViewController: MyCardTableViewCellDelegate {
    func cellTapped(card: Card?) {
        delegate?.buttonCardTapped(card: card)
    }
    
    func moreTapped(card: Card?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Xoá thẻ", style: .destructive) { (action) in
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            if let card = card, let cardID = card.shopID {
                weak var _self = self
                CardStore.deleteCard(cardID: cardID, completionHandler: { (success, error) in
                    
                    loadingNotification.hide(animated: true)
                    
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: self.view.bounds)
                            messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                            _self?.view.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if success {
                        if let cards = _self?.cards {
                            var tempCard: [Card] = [Card]()
                            for mainCard in cards {
                                if let mainCardID = mainCard.shopID {
                                    if mainCardID != cardID {
                                        tempCard.append(mainCard)
                                    }
                                }
                            }
                            _self?.cards = tempCard
                        }
                    }
                })
            }
        }
        alertController.addAction(deleteAction)
        
        let cancleAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alertController.addAction(cancleAction)
        
        if let window = self.view.window, let rootViewController = window.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }

    func shopTapped(card: Card?) {
        let shopDetailController = UIStoryboard(name: ShopDetailViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: ShopDetailViewController.identify) as! ShopDetailViewController
        shopDetailController.card = card
        if let window = self.view.window, let rootViewController = window.rootViewController {
            rootViewController.present(shopDetailController, animated: true, completion: nil)
        }
    }
}
