//
//  CardDetailViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 12/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class CardDetailViewController: BaseViewController {

    static let storyboardName = "Card"
    static let identify = "CardDetailViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var cardID: String?
    
    var card: Card? {
        didSet {
            if let card = card {
                let row: Int = 1
                
                if let discount = card.discount {
                    print("ok ")
                }
                
                self.rowNumber = row
            }
        }
    }
    
    var rowNumber: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: DetailCardHeaderTableViewCell.identify, bundle: nil), forCellReuseIdentifier: DetailCardHeaderTableViewCell.identify)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getCardDetail()
    }
    
    func getCardDetail() {
        if let cardID = cardID {
            CardStore.getCard(cardID: cardID, completionHandler: { (card, error) in
                guard error == nil else {
                    return
                }
                
                if let card = card {
                    self.card = card
                }
            })
        }
    }
    
    @IBAction func buttonAddCardTapped(_ sender: AnyObject) {
//        if !isAdded {
//            if let card = card, let cardID = card.shopID {
//                activityAddCard.startAnimating()
//                CardStore.addCard(cardID: cardID, completionHandler: { (success, error) in
//                    self.activityAddCard.stopAnimating()
//                    guard error == nil else {
//                        return
//                    }
//                    self.isAdded = success
//                })
//            }
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension CardDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCardHeaderTableViewCell.identify, for: indexPath) as! DetailCardHeaderTableViewCell
            cell.card = card
            return cell
        }
        return UITableViewCell()
    }
}
