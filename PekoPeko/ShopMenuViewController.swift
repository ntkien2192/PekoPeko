//
//  ShopMenuViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class CollectionCellItem: NSObject {
    var menuItems: [MenuItem]?
    var type: ItemType?
    
    func count() -> Int {
        if let menuItems = menuItems {
            return menuItems.count
        }
        return 0
    }
}

class ShopMenuViewController: BaseViewController {

    static let storyboardName = "Shop"
    static let identify = "ShopMenuViewController"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var segmentControl: SMSegmentView?
    
    var shop: Shop?
    
    var menuItems: [MenuItem]? {
        didSet {
            if let menuItems = menuItems {
                
                var mainCourse = [MenuItem]()
                var apertiser = [MenuItem]()
                var dessers = [MenuItem]()
                var drink = [MenuItem]()
                
                for item in menuItems {
                    if let foodType = item.foodType {
                        switch foodType {
                        case .mainCourse:
                            mainCourse.append(item)
                        case .apertiser:
                            apertiser.append(item)
                        case .dessers:
                            dessers.append(item)
                        case .drink:
                            drink.append(item)
                        }
                    }
                }
                
                var tempCollectionItem: [CollectionCellItem] = [CollectionCellItem]()
                
                if mainCourse.count != 0 {
                    let cellItem = CollectionCellItem()
                    cellItem.menuItems = mainCourse
                    cellItem.type = .mainCourse
                    tempCollectionItem.append(cellItem)
                }

                if apertiser.count != 0 {
                    let cellItem = CollectionCellItem()
                    cellItem.menuItems = apertiser
                    cellItem.type = .apertiser
                    tempCollectionItem.append(cellItem)
                }
                
                if dessers.count != 0 {
                    let cellItem = CollectionCellItem()
                    cellItem.menuItems = dessers
                    cellItem.type = .dessers
                    tempCollectionItem.append(cellItem)
                }
                
                if drink.count != 0 {
                    let cellItem = CollectionCellItem()
                    cellItem.menuItems = drink
                    cellItem.type = .drink
                    tempCollectionItem.append(cellItem)
                }
                
                collectionItem = tempCollectionItem
                
                
            }
        }
    }
    
    var collectionItem: [CollectionCellItem]? {
        didSet {
            collectionView.reloadData()
            
            setSegmentView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewConfig() {
        super.viewConfig()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        getShopMenuItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    func getShopMenuItem() {
        if let shop = shop {
            
            if let shopID = shop.shopID {
                weak var _self = self
                
                ShopStore.getShopMenuItem(shopID: shopID, completionHandler: { (menuItems, error) in
                    if let _self = _self {
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
                        
                        if let menuItems = menuItems {
                            _self.menuItems = menuItems
                        }
                    }
                })
            }

            if let name = shop.fullName {
                labelTitle.text = name
            }
        }
    }
    
    func setSegmentView() {

        if segmentControl == nil {
            let appearance = SMSegmentAppearance()
            appearance.segmentOnSelectionColour = UIColor.clear
            appearance.segmentOffSelectionColour = UIColor.clear
            appearance.contentVerticalMargin = 10.0
            segmentControl = SMSegmentView(frame: segmentView.bounds, dividerColour: UIColor.clear, dividerWidth: 1.0, segmentAppearance: appearance)
        }
        
        if let segmentControl = segmentControl {
            segmentControl.addTarget(self, action: #selector(ShopMenuViewController.selectSegmentInSegmentView), for: .valueChanged)
            
            if let collectionItem = collectionItem {
                for item in collectionItem {
                    if let type = item.type {
                        switch type {
                        case .mainCourse:
                            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType1"), offSelectionImage: UIImage(named: "IconFoodType1Off"))
                        case .apertiser:
                            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType2"), offSelectionImage: UIImage(named: "IconFoodType2Off"))
                        case .dessers:
                            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType3"), offSelectionImage: UIImage(named: "IconFoodType3Off"))
                        case .drink:
                            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType4"), offSelectionImage: UIImage(named: "IconFoodType4Off"))
                        }
                    }
                }
            }
            
            segmentControl.selectedSegmentIndex = 0
            
            segmentView.addSubview(segmentControl)
            segmentControl.translatesAutoresizingMaskIntoConstraints = false
            
            segmentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": segmentControl]))
            segmentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": segmentControl]))
        }
        
        collectionView.register(UINib(nibName: ShopMenuCollectionViewCell.identify, bundle: nil), forCellWithReuseIdentifier: ShopMenuCollectionViewCell.identify)
    }
    
    func selectSegmentInSegmentView() {
        if let segmentControl = segmentControl {
            collectionView.scrollToItem(at: IndexPath(row: segmentControl.selectedSegmentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}

extension ShopMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collectionItem = collectionItem {
            return collectionItem.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopMenuCollectionViewCell.identify, for: indexPath) as! ShopMenuCollectionViewCell
        if let collectionItem = collectionItem {
            cell.collectionCellItem = collectionItem[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let segmentControl = segmentControl {
            segmentControl.selectedSegmentIndex = Int(floor(scrollView.bounds.size.height / scrollView.contentOffset.y))
        }
    }
}
