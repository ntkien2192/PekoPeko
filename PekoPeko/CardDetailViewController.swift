//
//  CardDetailViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 12/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

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
    
    var isAdded: Bool = false {
        didSet {
            buttonAddCard.isHidden = false
            if isAdded {
                buttonAddCard.setTitle("Đã thêm", for: .normal)
            } else {
                buttonAddCard.setTitle("Thêm Thẻ", for: .normal)
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCardDetail()
    }
    
    func getCardDetail() {
        if let cardID = cardID {
            weak var _self = self
            CardStore.getCard(cardID: cardID, completionHandler: { (card, error) in
                guard error == nil else {
                    return
                }
                
                if let card = card {
                    _self?.card = card
                }
            })
        }
    }
    
    @IBAction func buttonAddCardTapped(_ sender: AnyObject) {
        if !isAdded {
            if let card = card, let cardID = card.shopID {
                weak var _self = self
                CardStore.addCard(cardID: cardID, completionHandler: { (success, error) in
                    guard error == nil else {
                        return
                    }
                    _self?.isAdded = success
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
        
    }
}
