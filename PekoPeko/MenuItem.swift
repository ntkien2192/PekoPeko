//
//  MenuItem.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

enum MenuItemFields: String {
    case ItemID = "_id"
    case Name = "name"
    case Desc = "desc"
    case ImageUrl = "image"
    case Rating = "rating"
    case Price = "price"
    case TotalReviews = "total_reviews"
    case TotalLikes = "total_likes"
    case IsLiked = "is_liked"
    case Category = "category"
    
    // get All Food
    case FoodType = "food_type"
}

enum ItemType: Int {
    case mainCourse = 1
    case apertiser = 2
    case dessers = 3
    case drink = 4
}

class MenuItem: NSObject {
    var itemID: String?
    var name: String?
    var desc: String?
    var imageUrl: String?
    var rating: Float?
    var price: Float?
    var totalReviews: Int?
    var totalLikes: Int?
    var isLiked: Bool?
    var categoryID: String?
    // get All Food
    var foodType: ItemType?
    
    required init(json: JSON) {
        itemID = json[MenuItemFields.ItemID.rawValue].string
        name = json[MenuItemFields.Name.rawValue].string
        desc = json[MenuItemFields.Desc.rawValue].string
        imageUrl = json[MenuItemFields.ImageUrl.rawValue].string
        rating = json[MenuItemFields.Rating.rawValue].float
        price = json[MenuItemFields.Price.rawValue].float
        totalReviews = json[MenuItemFields.TotalReviews.rawValue].int
        totalLikes = json[MenuItemFields.TotalLikes.rawValue].int
        isLiked = json[MenuItemFields.IsLiked.rawValue].bool
        categoryID = json[MenuItemFields.Category.rawValue].string
        // get All Food
        let type = json[MenuItemFields.FoodType.rawValue].intValue
        switch type {
        case 1:
            foodType = .mainCourse
        case 2:
            foodType = .apertiser
        case 3:
            foodType = .dessers
        case 4:
            foodType = .drink
        default:
            break
        }
    }
}
