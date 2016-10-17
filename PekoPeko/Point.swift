//
//  PointRequest.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 15/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

enum PointFields: String {
    case ShopID = "shop_id"
    case AddressID = "address_id"
    case Key = "key"
    case PointType = "type"
    case CreatedAt = "created_at"
    case PinCode = "pin_code"
    case HoneyPot = "honey_pot"
    case TotalBill = "total_bill"
    case HasDiscount = "has_buy1get1"
}

class Point: Mappable {
    // Request
    var shopID: String?
    var addressID: String?
    var key: String?
    var pointType: Int?
    var createdAt: Double?
    var pinCode: Int?
    var totalBill: Double?
    var hasDiscount: Bool?
    
    // Response
    var honeyPot: Int?
    
    init(shopID: String, addressID: String, pinCode: Int, key: String, pointType: Int, createdAt: Double, totalBill: Double, hasDiscount: Bool) {
        self.shopID = shopID
        self.addressID = addressID
        self.pinCode = pinCode
        self.key = key
        self.pointType = pointType
        self.createdAt = createdAt
        self.totalBill = totalBill
        self.hasDiscount = hasDiscount
    }
    
    required init(json: JSON) {
        shopID = json[PointFields.ShopID.rawValue].string
        addressID = json[PointFields.AddressID.rawValue].string
        pointType = json[PointFields.PointType.rawValue].int
        createdAt = json[PointFields.CreatedAt.rawValue].double
        key = json[PointFields.Key.rawValue].string
        honeyPot = json[PointFields.HoneyPot.rawValue].int
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        shopID <- map[PointFields.ShopID.rawValue]
        addressID <- map[PointFields.AddressID.rawValue]
        key <- map[PointFields.Key.rawValue]
        pointType <- map[PointFields.PointType.rawValue]
        createdAt <- map[PointFields.CreatedAt.rawValue]
        pinCode <- map[PointFields.PinCode.rawValue]
        hasDiscount <- map[PointFields.HasDiscount.rawValue]
        totalBill <- map[PointFields.TotalBill.rawValue]
    }
}
