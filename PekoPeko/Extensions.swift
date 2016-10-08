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
    
    class func RGB(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return RGBA(red, green: green, blue: blue, alpha: 255)
    }
    
    class func RGBA(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha/255)
    }
}
