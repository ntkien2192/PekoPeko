//
//  CardAddressViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 16/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

class CardAddressViewController: BaseViewController {

    static let storyboardName = "Redeem"
    static let identify = "CardAddressViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var addresses: [Address]?
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewConfig() {
        super.viewConfig()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: CardAddressTableViewCell.identify, bundle: nil), forCellReuseIdentifier: CardAddressTableViewCell.identify)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCardAddressInfo()
    }
    
    
    func loadCardAddressInfo() {
        if let card = card {
            if let shopName = card.shopName {
                labelTitle.text = shopName
            }
        }
        
        if addresses != nil {
            tableView.reloadData()
        }
    }
    
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CardAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let addresses = addresses {
            return addresses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardAddressTableViewCell.identify, for: indexPath) as! CardAddressTableViewCell
        if let addresses = addresses {
            cell.delegate = self
            cell.address = addresses[indexPath.row]
        }
        return cell
    }
}

extension CardAddressViewController: CardAddressTableViewCellDelegate {
    func addressTapped(address: Address?) {
        let addPointViewController = UIStoryboard(name: AddPointViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: AddPointViewController.identify) as! AddPointViewController
        addPointViewController.card = card
        addPointViewController.address = address
        present(addPointViewController, animated: true, completion: nil)
    }
}
