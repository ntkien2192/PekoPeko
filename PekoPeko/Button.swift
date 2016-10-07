//
//  Button.swift
//  Gomabu For Restaurant
//
//  Created by Nguyễn Trung Kiên on 19/05/2016.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import Foundation
import Spring

@IBDesignable

class Button: UIButton {
    
    /// Button corner radius
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
    /// Button border width
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /// Button border color
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            if shadow {
                layer.shadowColor = UIColor.darkGray.cgColor
                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                layer.shadowOpacity = 0.7
            }
        }
    }
    
}
