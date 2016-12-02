//
//  QRResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 15/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

enum QRCodeContentFields: String {
    case ShopID = "shop_id"
    case AddressID = "address_id"
    case Key = "key"
    case PointType = "type"
    case CreatedAt = "created_at"
    
    //QRCode
    case UserID = "userID"
    case TargetID = "targetID"
    case CardID = "cardID"
    case ScanType = "scanType"
}

class QRCodeContent: NSObject, Mappable {
    var shopID: String?
    var addressID: String?
    var key: String?
    var pointType: Int?
    var createdAt: Double?
    
    var userID = ""
    var targetID = ""
    var cardID = ""
    var scanType = ""
    
    override init() {}
    
    required init(json: JSON) {
        shopID = json[QRCodeContentFields.ShopID.rawValue].string
        addressID = json[QRCodeContentFields.AddressID.rawValue].string
        pointType = json[QRCodeContentFields.PointType.rawValue].int
        createdAt = json[QRCodeContentFields.CreatedAt.rawValue].double
        key = json[QRCodeContentFields.Key.rawValue].string
    }
    
    init(userID: String) {
        self.userID = userID
        self.scanType = "all"
    }
    
    init(userID: String, targetID: String, scanType: String) {
        self.userID = userID
        self.targetID = targetID
        self.scanType = scanType
    }
    
    init(userID: String, targetID: String, scanType: String, cardID: String) {
        self.userID = userID
        self.targetID = targetID
        self.scanType = scanType
        self.cardID = cardID
    }

    init(userID: String, scanType: String, cardID: String) {
        self.userID = userID
        self.scanType = scanType
        self.cardID = cardID
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        userID <- map[QRCodeContentFields.UserID.rawValue]
        targetID <- map[QRCodeContentFields.TargetID.rawValue]
        cardID <- map[QRCodeContentFields.CardID.rawValue]
        scanType <- map[QRCodeContentFields.ScanType.rawValue]
    }
}
