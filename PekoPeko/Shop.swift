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
    case Address = "address"
    
    // full info
    case CardIcon = "card_icon"
    case Categories = "categories"
    case TotalReviews = "totalReviews"
    case IsFollowing = "is_following"
    case TotalPhotos = "totalPhotos"
    case FollowBy = "follow_by"
    case MenuItems = "foods"
    case AvgPrice = "avg_price"
    case WorkTime = "opening_time"
    case Telephone = "phone"
}

class Shop: NSObject {
    var shopID: String?
    var fullName: String?
    var avatarUrl: String?
    var coverUrl: String?
    var rating: Float?
    var followers: Int?
    var canDiscount: Bool?
    var address: String?
    var addresses: [Address]?
    
    // full info
    var cardIcon: String?
    var categories: String?
    var totalReviews: Int?
    var isFollowing: Bool?
    var totalPhotos: Int?
    var followBy: [User]?
    var menuItems: [MenuItem]?
    var avgPrice: String?
    var workTime: WordTime?
    var telephone: String?
    
    required init(json: JSON) {
        shopID = json[ShopFields.ShopID.rawValue].string
        fullName = json[ShopFields.FullName.rawValue].string
        avatarUrl = json[ShopFields.AvatarUrl.rawValue].string
        coverUrl = json[ShopFields.CoverUrl.rawValue].string
        rating = json[ShopFields.Rating.rawValue].float
        followers = json[ShopFields.Followers.rawValue].int
        canDiscount = json[ShopFields.CanDiscount.rawValue].bool
        address = json[ShopFields.Address.rawValue].string
        addresses = json[ShopFields.Addresses.rawValue].arrayValue.map({ Address(json: $0) })
        
        // full info
        cardIcon = json[ShopFields.CardIcon.rawValue].string
        categories = json[ShopFields.Categories.rawValue].string
        totalReviews = json[ShopFields.TotalReviews.rawValue].int
        isFollowing = json[ShopFields.IsFollowing.rawValue].bool
        totalPhotos = json[ShopFields.TotalPhotos.rawValue].int
        followBy = json[ShopFields.FollowBy.rawValue].arrayValue.map({ User(json: $0) })
        menuItems = json[ShopFields.MenuItems.rawValue].arrayValue.map({ MenuItem(json: $0) })
        avgPrice = json[ShopFields.AvgPrice.rawValue].string
        workTime = WordTime(json: json[ShopFields.WorkTime.rawValue])
        telephone = json[ShopFields.Telephone.rawValue].string
    }
}
