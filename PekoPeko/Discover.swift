//
//  Discover.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

import SwiftyJSON

//enum DiscoverFields: String {
//    case DiscoverID = "_id"
//    case Content = "content"
//    case TotalSaves = "total_saves"
//    case DiscountRate = "discount_rate"
//    case PriceNew = "price_new"
//    
//    case PriceOld = "price_old"
//    case StartedAt = "started_at"
//    case EndedAt = "ended_at"
//    case ExpireAt = "expire_at"
//    case CreatedAt = "created_at"
//    case Shop = "shop"
//    
//    case Saved = "saved"
//    case DiscoverType = "type"
//    case TotalLikes = "total_likes"
//    case TotalComments = "total_comments"
//    case Liked = "liked"
//    case Image = "image"
//}
//
//class Discover: NSObject {
//    var addressID: String?
//    var addressContent: String?
//    var thumb: String?
//    var location: Location?
//    var qrCode: QRCode?
//    
//    required init(json: JSON) {
//        addressID = json[AddressFields.AddressID.rawValue].string
//        addressContent = json[AddressFields.Address.rawValue].string
//        thumb = json[AddressFields.Thumb.rawValue].string
//        location = Location(json: json[AddressFields.Location.rawValue])
//        addressID = json[AddressFields.AddressID.rawValue].string
//        if let data = json[AddressFields.QRData.rawValue].stringValue.data(using: String.Encoding.utf8) {
//            let json = JSON(data: data)
//            qrCode = QRCode(json: json)
//        }
//    }
//}
