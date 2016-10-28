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
    
    // v210
    case VipCard = "vipcard"
    case TotalHP = "total_hp"
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
    
    var vipCards: [VipCard]?
    var totalHp: Int?
    
    init(shop: Shop) {
        self.shopID = shop.shopID
        self.shopName = shop.fullName
        self.addressList = shop.addresses
        self.shopAvatarUrl = shop.avatarUrl
    }
    
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
        rewardTitle = json[CardFields.RewardTitle.rawValue].string
        
        // card detail
        shopPhone = json[CardFields.ShopPhone.rawValue].string
        avgPrice = json[CardFields.AvgPrice.rawValue].string
        isCanAdd = json[CardFields.CanAdd.rawValue].bool
        hpRate = json[CardFields.HPRate.rawValue].int
        isShopIpos = json[CardFields.ShopIpos.rawValue].bool
        rewards = json[CardFields.Rewards.rawValue].arrayValue.map({ AllReward(json: $0) })
        openingTime = WordTime(json: json[CardFields.ShopPhone.rawValue])
        
        vipCards = json[CardFields.VipCard.rawValue].arrayValue.map({ VipCard(json: $0) }).sorted(by: { (vip1, vip2) -> Bool in
            return (vip1.hpRequire ?? 0) < (vip2.hpRequire ?? 0)
        })
        totalHp = json[CardFields.TotalHP.rawValue].int
        
        if let vipCards = vipCards {
            for i in 0..<vipCards.count {
                if let hpRequire = vipCards[i].hpRequire {
                    
                    vipCards[i].needPoint = hpRequire - (totalHp ?? 0)
                    
                    if (totalHp ?? 0) >= hpRequire {
                        vipCards[i].isCurrent = true
                        vipCards[i].isLock = false
                        if i > 0 {
                            vipCards[i - 1].isCurrent = false
                        }
                    } else {
                        vipCards[i].isLock = true
                    }
                }
            }
        }
    }
    
    func isReward() -> Bool {
        if let hpCurrent = hpCurrent, let hpRequire = hpRequire {
            if hpCurrent >= hpRequire {
                return true
            } else {
                return false
            }
        }
        return false
    }
}


