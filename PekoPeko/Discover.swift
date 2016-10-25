//
//  Discover.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum DiscoverType: Int {
    case deal = 1
    case review = 2
}

enum DiscoverFields: String {
    case DiscoverID = "_id"
    case Content = "content"
    case TotalSaves = "total_saves"
    case DiscountRate = "discount_rate"
    case PriceNew = "price_new"
    case PriceOld = "price_old"
    case StartedAt = "started_at"
    case EndedAt = "ended_at"
    case ExpireAt = "expire_at"
    case CreatedAt = "created_at"
    case Shop = "shop"
    
    case Saved = "saved"
    case DiscoverType = "type"
    case TotalLikes = "total_likes"
    case TotalComments = "total_comments"
    case Liked = "liked"
    case Image = "images"
    case Steps = "steps"
    
}

class Discover: NSObject {
    var discoverID: String?
    var content: String?
    var totalSaves: Int?
    var discountRate: Float?
    var priceNew: Float?
    var priceOld: Float?
    var startedAt: Double?
    var endedAt: Double?
    var expireAt: Double?
    var createdAt: Double?
    var shop: Shop?
    var isSave: Bool?
    var discoverType: DiscoverType?
    var totalLikes: Int?
    var totalComments: Int?
    var isLiked: Bool?
    var image: Image?
    
    var steps: [DealStep]?
    
    required init(json: JSON) {
        discoverID = json[DiscoverFields.DiscoverID.rawValue].string
        content = json[DiscoverFields.Content.rawValue].string
        totalSaves = json[DiscoverFields.TotalSaves.rawValue].int
        discountRate = json[DiscoverFields.DiscountRate.rawValue].float
        priceNew = json[DiscoverFields.PriceNew.rawValue].float
        priceOld = json[DiscoverFields.PriceOld.rawValue].float
        
        startedAt = json[DiscoverFields.StartedAt.rawValue].double
        endedAt = json[DiscoverFields.EndedAt.rawValue].double
        expireAt = json[DiscoverFields.ExpireAt.rawValue].double
        createdAt = json[DiscoverFields.CreatedAt.rawValue].double
        
        shop = Shop(json: json[DiscoverFields.Shop.rawValue])
        isSave = json[DiscoverFields.Saved.rawValue].bool
        
        let type = json[DiscoverFields.DiscoverType.rawValue].intValue
        switch type {
        case 1:
            discoverType = .deal
        case 2:
            discoverType = .review
        default:
            break
        }
        
        totalLikes = json[DiscoverFields.TotalLikes.rawValue].int
        totalComments = json[DiscoverFields.TotalComments.rawValue].int
        isLiked = json[DiscoverFields.Liked.rawValue].bool
        image = Image(json: json[DiscoverFields.Image.rawValue])
        
        steps = json[DiscoverFields.Steps.rawValue].arrayValue.map({ DealStep(json: $0) })
    }
    
    func imageCount() -> Int {
        if let image = image, let urls = image.urls{
            return urls.count
        }
        return 0
    }
    
    func currentStep() -> DealStep? {
        if let steps = steps {
            var tempCurrentStep = DealStep()
            for step in steps {
                if let saveRequire = step.saveRequire, let totalSaves = totalSaves {
                    if totalSaves > saveRequire {
                        tempCurrentStep = step
                    }
                }
            }
            return tempCurrentStep
        }
        return nil
    }
    
    func firstStep() -> DealStep? {
        if let steps = steps {
            if let step = steps.first {
                return step
            }
            
        }
        return nil
    }
}
