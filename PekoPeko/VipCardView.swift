//
//  VipCardView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import iCarousel

class VipCardView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cardView: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var user: User?
    
    var vipCards: [VipCard]? {
        didSet {
            if let vipCards = vipCards {
                if vipCards.count <= 1 {
                    cardView.isScrollEnabled = false
                }
                
                var tempViewCard = [CardView]()
                for card in vipCards {
                    let view = CardView(frame: CGRect(x: 0, y: 0, width: cardView.bounds.width - 40, height: cardView.bounds.height))
                    view.vipCard = card
                    view.user = user
                    tempViewCard.append(view)
                }
                viewCard = tempViewCard
            }
        }
    }
    
    var viewCard: [CardView]? {
        didSet {
            if let viewCard = viewCard {
                pageControl.numberOfPages = viewCard.count
                cardView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("VipCardView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.layoutIfNeeded()
        
        cardView.type = .rotary
        cardView.alpha = 0

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIApplication.shared.statusBarStyle = .lightContent
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cardView.alpha = 1.0
        })
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        weak var _self = self
        UIView.animate(withDuration: 0.2, animations: {
            _self?.alpha = 0.0
        }) { _ in
            _self?.removeFromSuperview()
        }
    }
}


extension VipCardView: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        if let viewCard = viewCard {
            return viewCard.count
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if let viewCard = viewCard {
            return viewCard[index]
        }
        return UIView()
    }

    func carouselDidScroll(_ carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
}
