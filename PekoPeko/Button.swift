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

class Button: SpringButton {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
