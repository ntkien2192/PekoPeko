//
//  MyCardViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol MyCardViewControllerDelegate: class {
    func myCardTapped(card: Card?)
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
        getMyCard()
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
        
        CardStore.getUserCard(cardRequest: cardRequest) { (cardResponse, error) in
            if let refreshControl = self.refreshControl{
                refreshControl.endRefreshing()
            }
            guard error == nil else {
                return
            }
            
            if let cardResponse = cardResponse {
                if let cards = cardResponse.cards {
                    self.cards = cards
                }
                if let pagination = cardResponse.pagination, let nextPage = pagination.nextPage {
                    self.nextPage = nextPage
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCardTableViewCell.identify, for: indexPath) as! MyCardTableViewCell
        cell.delegate = self
        if let cards = cards {
            cell.card = cards[indexPath.row]
        }
        return cell
    }
}

extension MyCardViewController: MyCardTableViewCellDelegate {
    func cellTapped(card: Card?) {
        delegate?.myCardTapped(card: card)
    }
}
