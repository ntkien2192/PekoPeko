//
//  SegmentControl.swift
//  Gomabu For Restaurant
//
//  Created by Nguyễn Trung Kiên on 17/08/2016.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import UIKit
import NYSegmentedControl

protocol SegmentControlDelegate: class {
    func didSelect(_ item: [String], index: UInt)
}

class SegmentControl: UIView {

    weak var delegate: SegmentControlDelegate?
    
    var segmentedControl: NYSegmentedControl?
    
    var item: [String] = [String]() {
        didSet {
            commonInit()
        }
    }
    
    func setSelected(_ index: UInt) {
        if let segmentedControl = segmentedControl {
            segmentedControl.selectedSegmentIndex = index
        }
    }
    
    func setSegment(_ items: [String]) {
        for view in subviews {
            view.removeFromSuperview()
        }
        item = items
        
        for constraint in self.constraints {
            if constraint.firstAttribute == .width {
                if constraint.relation == .equal {
                     constraint.constant = CGFloat(item.count) * 150.0
                }
            }
        }
    }
    
    func commonInit() {
        segmentedControl = NYSegmentedControl(items: item)
        if let segmentedControl = segmentedControl {
            segmentedControl.backgroundColor = UIColor.clear
            segmentedControl.segmentIndicatorBackgroundColor = UIColor ( red: 0.7843, green: 0.2078, blue: 0.2235, alpha: 1.0 )
            segmentedControl.segmentIndicatorInset = 0.0
            segmentedControl.titleTextColor = UIColor.darkGray
            segmentedControl.selectedTitleTextColor = UIColor.white
            segmentedControl.cornerRadius = 0.0
            segmentedControl.borderWidth = 0.0
            segmentedControl.titleFont = UIFont.getFont(size: 16)
            segmentedControl.selectedTitleFont = UIFont.getFont(size: 16)
            segmentedControl.borderColor = UIColor.clear
            segmentedControl.segmentIndicatorBorderWidth = 0.0
            segmentedControl.addTarget(self, action: #selector(SegmentControl.segmentSelected), for: .valueChanged)
            segmentedControl.sizeToFit()
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(segmentedControl)
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": segmentedControl]));
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": segmentedControl]));
        }
    }
    
    func segmentSelected() {
        if let segmentedControl = segmentedControl {
            delegate?.didSelect(item, index: segmentedControl.selectedSegmentIndex)
        }
    }
    
}
