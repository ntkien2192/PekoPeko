//
//  ScrollView.swift
//  Gomabu For Restaurant
//
//  Created by Nguyễn Trung Kiên on 28/07/2016.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    /// BorderView corner radius
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
    /// BorderView border width
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /// BorderView border color
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

}
