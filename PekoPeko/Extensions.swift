//
//  Extensions.swift
//  Gomabu For Restaurant
//
//  Created by Hieu Tran on 3/10/16.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    @nonobjc static let colorOrange = UIColor(hex: "#F55722")
    @nonobjc static let colorGray = UIColor(hex: "#B3B3B3")
    @nonobjc static let colorBrown = UIColor(hex: "#411D11")
    @nonobjc static let colorRed = UIColor(hex: "#E01C23")
    
    class func RGB(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return RGBA(red, green: green, blue: blue, alpha: 255.0)
    }
    
    class func RGBA(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: (alpha * 255.0)/255.0)
    }
}

extension UIFont {
    class func getFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }
    
    class func getBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }
    
    class func getBlackFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }
}
