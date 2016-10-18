//
//  CardAddressView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 17/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol CardAddressViewDelegate: class {
    func addressTapped(address: Address?)
}

class CardAddressView: UIView {

    weak var delegate: CardAddressViewDelegate?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    var addresses: [Address]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CardAddressView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: CardAddressTableViewCell.identify, bundle: nil), forCellReuseIdentifier: CardAddressTableViewCell.identify)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        tableView.reloadData()
    }

    @IBAction func buttonCloseTapped(_ sender: AnyObject) {
        closeView()
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

extension CardAddressView: UITableViewDataSource {
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

extension CardAddressView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension CardAddressView: CardAddressTableViewCellDelegate {
    func addressTapped(address: Address?) {
        delegate?.addressTapped(address: address)
        closeView()
    }
}
