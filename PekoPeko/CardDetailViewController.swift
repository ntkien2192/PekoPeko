//
//  CardDetailViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 12/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

enum RowDisplayType: Int {
    case header = -10
    case discount = -9
    case hpRate = -8
}

class CardDetailViewController: BaseViewController {

    static let storyboardName = "Card"
    static let identify = "CardDetailViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonAddCard: Button!
    
    var refreshControl: UIRefreshControl?
    
    var rowDisplayType: [Int] = [Int]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cardID: String?
    
    var card: Card? {
        didSet {
            if let card = card {
                
                var type: [Int] = [Int]()
                type.append(RowDisplayType.header.rawValue)
                
                if card.discount != nil {
                    type.append(RowDisplayType.discount.rawValue)
                }
                
                if card.hpRate != nil {
                    type.append(RowDisplayType.hpRate.rawValue)
                }
                
                isAdded = card.isAdded ?? false
                
                if let rewards = card.rewards {
                    for reward in rewards {
                        if let isCurrent = reward.isCurrent {
                            if isCurrent {
                                if let rewardContent = reward.rewards {
                                    for i in 0..<rewardContent.count {
                                        type.append(i)
                                    }
                                    self.rewards = rewardContent
                                }
                            }
                        }
                    }
                }
                self.rowDisplayType = type
            }
        }
    }
    
    var addresses: [Address]?
    
    var isAdded: Bool = false {
        didSet {
            if !isAdded {
                buttonAddCard.isHidden = false
                buttonAddCard.setTitle("Lưu thẻ", for: .normal)
            } else {
                buttonAddCard.isHidden = true
            }
        }
    }
    
    var rewards: [Reward]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: DetailCardHeaderTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DetailCardHeaderTableViewCell.identify)
        tableView.register(UINib(nibName: DiscountCardTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DiscountCardTableViewCell.identify)
        tableView.register(UINib(nibName: PointCardTableViewCell.identify, bundle: nil), forCellReuseIdentifier: PointCardTableViewCell.identify)
        tableView.register(UINib(nibName: RewardTableViewCell.identify, bundle: nil), forCellReuseIdentifier: RewardTableViewCell.identify)
        tableView.register(UINib(nibName: Reward10TableViewCell.identify, bundle: nil), forCellReuseIdentifier: Reward10TableViewCell.identify)
        
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(CardDetailViewController.reloadCardInfo), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCardInfo()
    }
    
    func reloadCardInfo() {
        getCardInfo()
        getCardAddress()
    }
    
    func getCardInfo() {
        if let cardID = cardID {
            weak var _self = self
            CardStore.getCardInfo(cardID: cardID, completionHandler: { (card, error) in
                if let _self = _self {
                    if let refreshControl = _self.refreshControl {
                        refreshControl.endRefreshing()
                    }
                    
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: _self.view.bounds)
                            messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                            _self.view.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if let card = card {
                        _self.card = card
                    }
                }
            })
        }
    }
    
    func getCardAddress() {
        if let cardID = cardID {
            weak var _self = self
            CardStore.getCardAddress(cardID: cardID, completionHandler: { (addresses, error) in
                if let _self = _self {
                    if let refreshControl = _self.refreshControl {
                        refreshControl.endRefreshing()
                    }
                    guard error == nil else {
                        if let error = error as? ServerResponseError, let data = error.data {
                            let messageView = MessageView(frame: _self.view.bounds)
                            messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                            _self.view.addFullView(view: messageView)
                        }
                        return
                    }
                    
                    if let addresses = addresses {
                        _self.addresses = addresses
                    }
                }
            })
        }
    }
    
    @IBAction func buttonAddCardTapped(_ sender: AnyObject) {
        if !isAdded {
            if let card = card, let cardID = card.shopID {
                weak var _self = self
                CardStore.addCard(cardID: cardID, completionHandler: { (success, error) in
                    if let _self = _self {
                        guard error == nil else {
                            if let error = error as? ServerResponseError, let data = error.data {
                                let messageView = MessageView(frame: _self.view.bounds)
                                messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                                self.view.addFullView(view: messageView)
                            }
                            return
                        }
                        _self.isAdded = success
                    }

                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension CardDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowDisplayType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = rowDisplayType[indexPath.row]
        
        switch cellType {
        case -10:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCardHeaderTableViewCell.identify, for: indexPath) as! DetailCardHeaderTableViewCell
            cell.card = card
            cell.delegate = self
            return cell
        case -9:
            let cell = tableView.dequeueReusableCell(withIdentifier: DiscountCardTableViewCell.identify, for: indexPath) as! DiscountCardTableViewCell
            cell.card = card
            return cell
        case -8:
            let cell = tableView.dequeueReusableCell(withIdentifier: PointCardTableViewCell.identify, for: indexPath) as! PointCardTableViewCell
            cell.card = card
            return cell
        default:
            if let rewards = rewards {
                let reward = rewards[cellType]
                if let hpRequire = reward.hpRequire {
                    if hpRequire <= 5 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: RewardTableViewCell.identify, for: indexPath) as! RewardTableViewCell
                        cell.reward = rewards[cellType]
                        cell.delegate = self
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: Reward10TableViewCell.identify, for: indexPath) as! Reward10TableViewCell
                        cell.reward = rewards[cellType]
                        cell.delegate = self
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
}

extension CardDetailViewController: RewardTableViewCellDelegate, Reward10TableViewCellDelegate {
    func buttonExchangeTapped(reward: Reward?) {
        let redeemViewController = UIStoryboard(name: RedeemViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: RedeemViewController.identify) as! RedeemViewController
        redeemViewController.reward = reward
        if let card = card {
            redeemViewController.card = card
        }
        if let window = self.view.window, let rootViewController = window.rootViewController {
            rootViewController.present(redeemViewController, animated: true, completion: nil)
        }
    }
    
    func buttonPointTapped(reward: Reward?) {
        if let addresses = addresses {
            if addresses.count == 1 {
                let addPointViewController = UIStoryboard(name: AddPointViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: AddPointViewController.identify) as! AddPointViewController
                addPointViewController.card = card
                addPointViewController.address = addresses.first
                addPointViewController.delegate = self
                if let window = self.view.window, let rootViewController = window.rootViewController {
                    rootViewController.present(addPointViewController, animated: true, completion: nil)
                }
            } else if addresses.count > 1 {
                let cardAddressView = CardAddressView(frame: view.bounds)
                cardAddressView.addresses = addresses
                cardAddressView.delegate = self
                self.view.addFullView(view: cardAddressView)
            }
        } else {
            getCardAddress()
        }
    }
}

extension CardDetailViewController: CardAddressViewDelegate {
    func addressTapped(address: Address?) {
        let addPointViewController = UIStoryboard(name: AddPointViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: AddPointViewController.identify) as! AddPointViewController
        addPointViewController.card = card
        addPointViewController.address = address
        addPointViewController.delegate = self
        if let window = self.view.window, let rootViewController = window.rootViewController {
            rootViewController.present(addPointViewController, animated: true, completion: nil)
        }
    }
}

extension CardDetailViewController: AddPointViewControllerDelegate {
    func pointAdded(point: Point?) {
        if let point = point {
            let messageView = MessageView(frame: view.bounds)
            if let honeyPot = point.honeyPot {
                if honeyPot == 0 {
                    messageView.message = "Tổng hoá đơn của bạn không đủ lớn để nhận điểm"
                } else {
                    messageView.message = "Bạn đã nhận được \(honeyPot) điểm"
                }
            }
            self.view.addFullView(view: messageView)
        }
    }
}

// MARK: Cell Delegate

extension CardDetailViewController: DetailCardHeaderTableViewCellDelegate {
    func shopTapped(card: Card?) {
        let shopDetailController = UIStoryboard(name: ShopDetailViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: ShopDetailViewController.identify) as! ShopDetailViewController
        shopDetailController.card = card
        if let window = self.view.window, let rootViewController = window.rootViewController {
            rootViewController.present(shopDetailController, animated: true, completion: nil)
        }
    }
}
