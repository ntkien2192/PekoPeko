//
//  Discount.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 15/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum DiscountFields: String {
    case Uses = "uses"
    case Visible = "visible"
    
    // card detail
    case Title = "title"
    case EndedAt = "ended_at"
    case Use = "use"
    case Total = "total"
    case Cover = "cover"
}

class Discount: NSObject {
    var userNumber: Int?
    var isVisible: Bool?
    
    var title: String?
    var endedAt: Date?
    var isNeverEnd:Bool?
    var use: Int?
    var total: Int?
    var coverUrl: String?
    
    required init(json: JSON) {
        userNumber = json[DiscountFields.Uses.rawValue].int
        isVisible = json[DiscountFields.Visible.rawValue].bool
        
        title = json[DiscountFields.Title.rawValue].string
        let time = json[DiscountFields.EndedAt.rawValue].double
        if let time = time {
            if time < 0 {
                isNeverEnd = true
            } else {
                isNeverEnd = false
                endedAt = Date(timeIntervalSince1970: time)
            }
        }
        use = json[DiscountFields.Use.rawValue].int
        total = json[DiscountFields.Total.rawValue].int
        coverUrl = json[DiscountFields.Cover.rawValue].string
    }
}
