//
//  Voucher.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum VoucherFields: String {
    case Title = "title"
    case Image = "image"
    case TotalUses = "total_uses"
    case MaxUses = "max_uses"
    case CreatedAt = "created_at"
    case Shop = "shop"
}

class Voucher: NSObject {
    var title: String?
    var image: String?
    var totalUses: Int?
    var maxUses: Int?
    var createdAt: Double?
    var shop: Shop?
    
    required init(json: JSON) {
        title = json[VoucherFields.Title.rawValue].string
        image = json[VoucherFields.Image.rawValue].string
        totalUses = json[VoucherFields.TotalUses.rawValue].int
        maxUses = json[VoucherFields.MaxUses.rawValue].int
        createdAt = json[VoucherFields.CreatedAt.rawValue].double
        shop = Shop(json: json[VoucherFields.Shop.rawValue])
    }
}
