//
//  DealTableHeaderView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol DealTableHeaderViewDelegate: class {
    func discoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
    func likeDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void)
}

class DealTableHeaderView: UIView {

    weak var delegate: DealTableHeaderViewDelegate?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var deals: [Discover]? {
        didSet {
            if let deals = deals {
                collectionView.reloadData()
                pageControl.numberOfPages = deals.count
                if deals.count > 1 {
                    scroll()
                }
            }
        }
    }
    
    var isScrolling = false
    var cellIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("DealTableHeaderView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        
        collectionView.register(UINib(nibName: DealTableHeaderViewCell.identify, bundle: nil), forCellWithReuseIdentifier: DealTableHeaderViewCell.identify)
        
        self.layoutIfNeeded()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if collectionView.tag == 0 {
            collectionView.tag = 1
            scroll()
        }
    }
    
    func scroll() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if !self.isScrolling {
                self.scrolling()
            }
            self.scroll()
        }
    }
    
    func scrolling() {
        if let deals = deals {
            if cellIndex < deals.count - 1 {
                cellIndex = cellIndex + 1
            } else {
                cellIndex = 0
            }
            
            pageControl.currentPage = cellIndex
            
            collectionView.scrollToItem(at: IndexPath(item: cellIndex, section: 0), at: .left, animated: true)
        }
    }
    
    func reloadPage() {
        let currentPage = collectionView.contentOffset.x / collectionView.bounds.size.width
        
        if (0.0 != fmodf(Float(currentPage), 1.0)) {
            pageControl.currentPage = Int(currentPage) + 1
            cellIndex = Int(currentPage)
        } else {
            pageControl.currentPage = Int(currentPage)
            cellIndex = Int(currentPage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DealTableHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let deals = deals {
            return deals.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DealTableHeaderViewCell.identify, for: indexPath) as! DealTableHeaderViewCell
        
        if let deals = deals {
            cell.discover = deals[indexPath.row]
        }
        
        cell.delegate = self
        
        return cell
    }
}

extension DealTableHeaderView: DealTableHeaderViewCellDelegate {
    func discoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void) {
        delegate?.discoverTapped(discover: discover, completionHandler: { newDiscover in
            completionHandler(newDiscover)
        })
    }
    
    func likeDiscoverTapped(discover: Discover?, completionHandler: @escaping (Discover?) -> Void) {
        delegate?.likeDiscoverTapped(discover: discover, completionHandler: { newDiscover in
            completionHandler(newDiscover)
        })
    }
}

extension DealTableHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.size.width, height: bounds.size.height - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DealTableHeaderView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
        reloadPage()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrolling = false
        reloadPage()
    }
}
