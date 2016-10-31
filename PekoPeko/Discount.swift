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
    case Total = "total"
    case Cover = "cover"
}

class Discount: NSObject {
    var usesNumber: Int?
    var isVisible: Bool?
    
    var title: String?
    var endedAt: Double?
    var isNeverEnd:Bool?
    var total: Int?
    var coverUrl: String?
    
    required init(json: JSON) {
        usesNumber = json[DiscountFields.Uses.rawValue].int
        isVisible = json[DiscountFields.Visible.rawValue].bool
        
        title = json[DiscountFields.Title.rawValue].string
        endedAt = json[DiscountFields.EndedAt.rawValue].double
        if let endedAt = endedAt {
            if endedAt < 0 {
                isNeverEnd = true
            } else {
                isNeverEnd = false
            }
        }
        total = json[DiscountFields.Total.rawValue].int
        coverUrl = json[DiscountFields.Cover.rawValue].string
    }
}
