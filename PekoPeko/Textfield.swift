//
//  Textfield.swift
//  Gomabu For Restaurant
//
//  Created by Nguyễn Trung Kiên on 25/05/2016.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import UIKit
import Spring

@IBDesignable

class Textfield: SpringTextField {

    var dropdownIconImageView: UIImageView?
    
    /// Textfield corner radius
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
    /// Textfield border width
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /// Textfield border color
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// Textfield Placeholder Color
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            if let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes:[NSForegroundColorAttributeName: placeholderColor])
            }
        }
    }

    /// Textfield Left Inset
    @IBInspectable var leftInset: CGFloat = 0.0 {
        didSet {
            leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: leftInset, height: 0))
            leftViewMode = UITextFieldViewMode.always
        }
    }
    
    /// Textfield Right Inset
    @IBInspectable var rightInset: CGFloat = 0.0 {
        didSet {
            rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: rightInset, height: 0))
            rightViewMode = UITextFieldViewMode.always
        }
    }
    
}
