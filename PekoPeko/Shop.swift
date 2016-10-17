//
//  Shop.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 17/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

enum ShopFields: String {
    case ShopID = "_id"
    case FullName = "full_name"
    case AvatarUrl = "avatar"
    case CoverUrl = "cover"
    case Rating = "rating"
    case Followers = "followers"
    case CanDiscount = "can_buy1get1"
    case Addresses = "addresses"
}

class Shop: NSObject {
    var shopID: String?
    var fullName: String?
    var avatarUrl: String?
    var coverUrl: String?
    var rating: Float?
    var followers: Int?
    var canDiscount: Bool?
    var addresses: [Address]?
    
    required init(json: JSON) {
        shopID = json[ShopFields.ShopID.rawValue].string
        fullName = json[ShopFields.FullName.rawValue].string
        avatarUrl = json[ShopFields.AvatarUrl.rawValue].string
        coverUrl = json[ShopFields.CoverUrl.rawValue].string
        rating = json[ShopFields.Rating.rawValue].float
        followers = json[ShopFields.Followers.rawValue].int
        canDiscount = json[ShopFields.CanDiscount.rawValue].bool
        addresses = json[ShopFields.Addresses.rawValue].arrayValue.map({ Address(json: $0) })
    }
}
