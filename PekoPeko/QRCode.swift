//
//  QRResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 15/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum QRCodeFields: String {
    case ShopID = "shop_id"
    case AddressID = "address_id"
    case Key = "key"
    case PointType = "type"
    case CreatedAt = "created_at"
}

class QRCode: NSObject {
    var shopID: String?
    var addressID: String?
    var key: String?
    var pointType: Int?
    var createdAt: Double?
    
    override init() {}
    
    required init(json: JSON) {
        shopID = json[QRCodeFields.ShopID.rawValue].string
        addressID = json[QRCodeFields.AddressID.rawValue].string
        pointType = json[QRCodeFields.PointType.rawValue].int
        createdAt = json[QRCodeFields.CreatedAt.rawValue].double
        key = json[QRCodeFields.Key.rawValue].string
    }
}
