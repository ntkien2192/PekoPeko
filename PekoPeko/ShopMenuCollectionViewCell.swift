//
//  ShopMenuCollectionViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 19/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class ShopMenuCollectionViewCell: UICollectionViewCell {

    static let identify = "ShopMenuCollectionViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var collectionCellItem: CollectionCellItem? {
        didSet {
            if let collectionCellItem = collectionCellItem, let menuItems = collectionCellItem.menuItems {
                
                var tempMenuItems = [MenuItem]()
                tempMenuItems.append(contentsOf: menuItems)
                
                var tempArr = [MenuCellItem]()
                
                if tempMenuItems.count != 0 {
                    for _ in 0..<Int(tempMenuItems.count / 2) {
                        let menuCellItem = MenuCellItem(item1: tempMenuItems[0], item2: tempMenuItems[1])
                        tempArr.append(menuCellItem)
                        tempMenuItems.remove(at: 0)
                        tempMenuItems.remove(at: 0)
                    }
                    
                    if tempMenuItems.count != 0 {
                        let menuCellItem = MenuCellItem(item: tempMenuItems[0])
                        tempArr.append(menuCellItem)
                        tempMenuItems.remove(at: 0)
                    }
                }
                
                self.menuCellItem = tempArr
            }
        }
    }
    
    var menuCellItem: [MenuCellItem]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: ShopMenu2TableViewCell.identify, bundle: nil), forCellReuseIdentifier: ShopMenu2TableViewCell.identify)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        
        tableView.reloadData()
    }

}


extension ShopMenuCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let menuCellItem = menuCellItem {
            return menuCellItem.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopMenu2TableViewCell.identify, for: indexPath) as! ShopMenu2TableViewCell
        if let menuCellItem = menuCellItem {
            cell.menuCellItem = menuCellItem[indexPath.row]
        }
        return cell
    }
}


extension ShopMenuCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
