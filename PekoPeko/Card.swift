//
//  Card.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 11/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

enum PaginationFields: String {
    case NextPage = "next"
}

class Pagination: NSObject {
    var nextPage: String?
    
    required init(json: JSON) {
        nextPage = json[PaginationFields.NextPage.rawValue].string
    }
}

enum AllRewardFields: String {
    case Current = "current"
    case Rewards = "rewards"
}

class AllReward: NSObject {
    var isCurrent: Bool?
    var rewards: [Reward]?
    
    required init(json: JSON) {
        isCurrent = json[AllRewardFields.Current.rawValue].bool
        rewards = json[AllRewardFields.Rewards.rawValue].arrayValue.map({ Reward(json: $0) })
    }
}

enum WordTimeFields: String {
    case Open = "open"
    case Close = "close"
}

class WordTime: NSObject {
    var openTime: String?
    var closeTime: String?
    
    required init(json: JSON) {
        openTime = json[WordTimeFields.Open.rawValue].string
        closeTime = json[WordTimeFields.Close.rawValue].string
    }
}

enum AddressFields: String {
    case AddressID = "_id"
    case Address = "address"
    case Thumb = "thumb"
    case Location = "location"
    case QRData = "qr_data"
}

class Address: NSObject {
    var addressID: String?
    var addressContent: String?
    var thumb: String?
    var location: Location?
    var qrCode: QRCode?
    
    required init(json: JSON) {
        addressID = json[AddressFields.AddressID.rawValue].string
        addressContent = json[AddressFields.Address.rawValue].string
        thumb = json[AddressFields.Thumb.rawValue].string
        location = Location(json: json[AddressFields.Location.rawValue])
        addressID = json[AddressFields.AddressID.rawValue].string
        qrCode = QRCode(json: SwiftyJSON.JSON(json[AddressFields.AddressID.rawValue].stringValue))
    }
}

enum CardFields: String {
    case ShopID = "shop_id"
    case ShopName = "shop_name"
    case ShopAddress = "shop_address"
    case CardAddress = "address"
    case Distance = "distance"
    case Followers = "followers"
    case Rating = "rating"
    case ShopCoverUrl = "shop_cover"
    case ShopAvatarUrl = "shop_avatar"
    case Added = "added"
    case Discount = "buy1get1"
    
    //my Card
    case AddressID = "address_id"
    case HPRequire = "hp_require"
    case RewardTitle = "reward_title"
    case HPCurrent = "hp_current"
    
    // card Detail
    case ShopPhone = "shop_phone"
    case AvgPrice = "avg_price"
    case CanAdd = "can_add"
    case HPRate = "hp_rate"
    case ShopIpos = "shop_ipos"
    case Rewards = "rewards"
    case OpeningTime = "opening_time"
}

class Card: NSObject {
    var shopID: String?
    var shopName: String?
    var shopAddress: String?
    var cardAddress: String?
    var distance: String?
    var followers: Int?
    var rating: Float?
    var shopCoverUrl: String?
    var shopAvatarUrl: String?
    var isAdded: Bool!
    var discount: Discount?
    
    // my Card
    var addressID: String?
    var hpRequire: Int?
    var hpCurrent: Int?
    var rewardTitle: String?
    
    // card detail
    var shopPhone: String?
    var avgPrice: String?
    var isCanAdd: Bool?
    var hpRate: Int?
    var isShopIpos: Bool?
    var rewards: [AllReward]?
    var openingTime: WordTime?
    
    // List address
    var addressList: [Address]?
    
    required init(json: JSON) {
        shopID = json[CardFields.ShopID.rawValue].string
        shopName = json[CardFields.ShopName.rawValue].string
        shopAddress = json[CardFields.ShopAddress.rawValue].string
        cardAddress = json[CardFields.CardAddress.rawValue].string
        distance = json[CardFields.Distance.rawValue].string
        followers = json[CardFields.Followers.rawValue].intValue
        rating = json[CardFields.Rating.rawValue].floatValue
        shopCoverUrl = json[CardFields.ShopCoverUrl.rawValue].string
        shopAvatarUrl = json[CardFields.ShopAvatarUrl.rawValue].string
        isAdded = json[CardFields.Added.rawValue].boolValue
        if json[CardFields.Discount.rawValue] != nil {
            discount = Discount(json: json[CardFields.Discount.rawValue])
        }
        
        // my Card
        addressID = json[CardFields.AddressID.rawValue].string
        hpRequire = json[CardFields.HPRequire.rawValue].int
        hpCurrent = json[CardFields.HPCurrent.rawValue].int
        rewardTitle = json[CardFields.AddressID.rawValue].string
        
        // card detail
        shopPhone = json[CardFields.ShopPhone.rawValue].string
        avgPrice = json[CardFields.AvgPrice.rawValue].string
        isCanAdd = json[CardFields.CanAdd.rawValue].bool
        hpRate = json[CardFields.HPRate.rawValue].int
        isShopIpos = json[CardFields.ShopIpos.rawValue].bool
        rewards = json[CardFields.Rewards.rawValue].arrayValue.map({ AllReward(json: $0) })
        openingTime = WordTime(json: json[CardFields.ShopPhone.rawValue])
    }
}


