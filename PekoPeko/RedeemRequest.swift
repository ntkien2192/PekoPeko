//
//  RedeemRequest.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper

enum RedeemRequestFields: String {
    case ShopID = "shop_id"
    case RewardID = "reward_id"
    case PinCode = "pin_code"
}

class RedeemRequest: Mappable {
    var shopID: String?
    var redeemID: String?
    var pinCode: Int?
    var pinCodeString: String?
    
    required init(shopID: String, redeemID: String, pinCode: Int) {
        self.shopID = shopID
        self.redeemID = redeemID
        self.pinCode = pinCode
    }
    
    required init(pinCode: Int) {
        self.pinCode = pinCode
    }
    
    required init(pinCodeString: String) {
        self.pinCodeString = pinCodeString
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        shopID <- map[RedeemRequestFields.ShopID.rawValue]
        redeemID <- map[RedeemRequestFields.RewardID.rawValue]
        pinCode <- map[RedeemRequestFields.PinCode.rawValue]
        pinCodeString <- map[RedeemRequestFields.PinCode.rawValue]
    }
}
