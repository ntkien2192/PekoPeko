
//
//  DealMultiPriceTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 26/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import LDProgressView

class DealMultiPriceTableViewCell: UITableViewCell {

    static let identify = "DealMultiPriceTableViewCell"
    
    @IBOutlet weak var loadView: UIView!
    @IBOutlet weak var segmenControlPrice: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelOldPrice: UILabel!
    
    var progressView: LDProgressView?
    
    var discover: Discover? {
        didSet {
            if let discover = discover {
                if let steps = discover.steps {
                    segmenControlPrice.removeAllSegments()
                    
                    if let priceOld = discover.priceOld {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .currency
                        formatter.locale = Locale(identifier: "es_VN")
                        formatter.currencySymbol = "VND"
                        
                        labelOldPrice.text = "Giá cũ: \(NSString(format: "%@", formatter.string(from: NSNumber(value: priceOld))!))"
                    }
                    
                    var tempUsers = [String]()
                    tempUsers.append("0")
                    
                    var target = 0
                    
                    var big = 0
                    
                    for i in 0..<steps.count {
                        if let priceNew = steps[i].priceNew {
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .currency
                            formatter.locale = Locale(identifier: "es_VN")
                            formatter.currencySymbol = "VND"
                                
                            segmenControlPrice.insertSegment(withTitle: "\(NSString(format: "%@", formatter.string(from: NSNumber(value: priceNew))!))", at: i + 1, animated: false)
                        }
                        if let saveRequire = steps[i].saveRequire {
                            tempUsers.append("\(saveRequire)")
                            
                            if let totalSaves = discover.totalSaves {
                                if totalSaves >= saveRequire {
                                    target = i
                                }
                            }
                            
                            if saveRequire > big {
                                big = saveRequire
                            }
                        }
                    }
                    
                    if let progressView = progressView, let totalLikes = discover.totalLikes {
                        progressView.progress = CGFloat(totalLikes) / CGFloat(big)
                    }
                    
                    priceTarger = target
                    userTarget = target
                    users = tempUsers
                }
            }
        }
    }
    
    
    
    var priceTarger: Int = 0 {
        didSet {
            segmenControlPrice.selectedSegmentIndex = priceTarger
        }
    }
    
    var users: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var userTarget: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressView = LDProgressView(frame: loadView.bounds)
        if let progressView = progressView {
            progressView.flat = NSNumber(value: true)
            progressView.color = UIColor.colorOrange
            progressView.showText = NSNumber(value: false)
            progressView.borderRadius = NSNumber(value: 2.0)
            progressView.type = LDProgressStripes
            progressView.outerStrokeWidth = NSNumber(value: 0.5)
            progressView.background = UIColor.RGB(245, green: 245, blue: 245)
            progressView.showBackgroundInnerShadow = NSNumber(value: false)
            progressView.showStroke = NSNumber(value: true)
            progressView.animate = NSNumber(value: false)
            
            loadView.addSubview(progressView)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            loadView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": progressView]))
            loadView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": progressView]))
        }

        
        let normalAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.getFont(11)]
        let selectedAttributes = [NSForegroundColorAttributeName: UIColor.colorOrange, NSFontAttributeName: UIFont.getBoldFont(14)]
        segmenControlPrice.setTitleTextAttributes(selectedAttributes as [NSObject : AnyObject], for: .selected)
        segmenControlPrice.setTitleTextAttributes(normalAttributes as [NSObject : AnyObject], for: .normal)

        collectionView.register(UINib(nibName: DealMultiPriceCollectionViewCell.identify, bundle: nil), forCellWithReuseIdentifier: DealMultiPriceCollectionViewCell.identify)
    }
    
    @IBAction func segmentTapped(_ sender: AnyObject) {
        segmenControlPrice.selectedSegmentIndex = priceTarger
    }
}

extension DealMultiPriceTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let users = users {
            return users.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealMultiPriceCollectionViewCell.identify, for: indexPath) as! DealMultiPriceCollectionViewCell
        if let users = users {
            cell.text = users[indexPath.row]
            
            cell.isTarget = userTarget == indexPath.row
            
            switch indexPath.row {
            case 0:
                cell.labeltext.textAlignment = .left
            case users.count - 1:
                cell.labeltext.textAlignment = .right
            default:
                cell.labeltext.textAlignment = .center
            }
            
        }
        return cell
    }
}

extension DealMultiPriceTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let users = users {
            return CGSize(width: collectionView.bounds.width / CGFloat(users.count) , height: 28)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
