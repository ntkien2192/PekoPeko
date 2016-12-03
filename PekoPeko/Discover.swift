//
//  Discover.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum DealStep {
    case begin
    case canSave
    case needPay
    case canUse
    case used
    case close
}

enum DiscoverType: Int {
    case deal = 1
    case dealMulti = 2
}

enum DiscoverFields: String {
    case DiscoverID = "_id"
    case Content = "content"
    case Name = "name"
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
    case CoverImage = "image"
    case Steps = "steps"
    
    case SavedAt = "saved_at"
    case IsUsed = "is_used"
    
    case IsNoPin = "no_pin"
    
    case IsPayRequire = "is_prepaid"
}

class Discover: NSObject {
    var discoverID: String?
    var content: String?
    var name: String?
    var totalSaves: Int?
    var discountRate: Float?
    var priceNew: Float?
    var priceOld: Float?
    var startedAt: Double?
    var endedAt: (Int, Int, Int)?
    var expireAt: Double?
    var createdAt: Double?
    var shop: Shop?
    
    var isSave = false
    var discoverType: DiscoverType?
    var totalLikes: Int?
    var totalComments: Int?
    var isLiked: Bool = false
    var image: Image?
    var coverImage: String?
    var images: [Image]?
    var steps: [DealPayStep]?
    
    var savedAt: Double?
    
    var isUsed = false
    var isEnd = false
    
    var isNoPin = false
    
    var isPayRequire = false
    
    var step: DealStep {
        let isStart = Int(Date(timeIntervalSince1970: TimeInterval((startedAt ?? 0.0) / 1000.0)).timeIntervalSince(Date())) < 0 ? true : false
        let isExpire = Int(Date(timeIntervalSince1970: TimeInterval((expireAt ?? 0.0) / 1000.0)).timeIntervalSince(Date())) > 0 ? true : false
        
        if isStart {
            if !isEnd {
                if isSave {
                    if isUsed {
                        return .used
                    } else {
                        return .canUse
                    }
                } else {
                    if isPayRequire {
                        return .needPay
                    } else {
                        return .canSave
                    }
                }
            } else if !isExpire {
                if isSave {
                    if isUsed {
                        return .used
                    } else {
                        return .canUse
                    }
                } else {
                    return .close
                }
            } else {
                return .close
            }
        } else {
            return .begin
        }
    }
    
    required init(json: JSON) {
        discoverID = json[DiscoverFields.DiscoverID.rawValue].string
        content = json[DiscoverFields.Content.rawValue].string
        name = json[DiscoverFields.Name.rawValue].string
        totalSaves = json[DiscoverFields.TotalSaves.rawValue].int
        discountRate = json[DiscoverFields.DiscountRate.rawValue].float
        priceNew = json[DiscoverFields.PriceNew.rawValue].float
        priceOld = json[DiscoverFields.PriceOld.rawValue].float
        
        startedAt = json[DiscoverFields.StartedAt.rawValue].double
        
        let end = json[DiscoverFields.EndedAt.rawValue].doubleValue
        let time = Int(Date(timeIntervalSince1970: TimeInterval(end / 1000.0)).timeIntervalSince(Date()))
        isEnd = time > 0 ? false : true
        endedAt = (time < 0 ? 0 : time).secondsToDayHoursMinutes()
        
        expireAt = json[DiscoverFields.ExpireAt.rawValue].double
        
        createdAt = json[DiscoverFields.CreatedAt.rawValue].double
        
        shop = Shop(json: json[DiscoverFields.Shop.rawValue])
        isSave = json[DiscoverFields.Saved.rawValue].boolValue
        
        let type = json[DiscoverFields.DiscoverType.rawValue].intValue
        switch type {
        case 1:
            discoverType = .deal
        case 2:
            discoverType = .dealMulti
        default:
            break
        }
        
        totalLikes = json[DiscoverFields.TotalLikes.rawValue].int
        totalComments = json[DiscoverFields.TotalComments.rawValue].int
        isLiked = json[DiscoverFields.Liked.rawValue].boolValue
        image = Image(json: json[DiscoverFields.Image.rawValue])
        
        coverImage = json[DiscoverFields.CoverImage.rawValue].string
        
        steps = json[DiscoverFields.Steps.rawValue].arrayValue.map({ DealPayStep(json: $0) })
        
        savedAt = json[DiscoverFields.SavedAt.rawValue].double
        isUsed = json[DiscoverFields.IsUsed.rawValue].boolValue
        
        isNoPin = json[DiscoverFields.IsNoPin.rawValue].boolValue
        
        isPayRequire = json[DiscoverFields.IsPayRequire.rawValue].boolValue
    }
    
    func updateLike() -> Bool {
        isLiked = !isLiked
        
        if isLiked {
            totalLikes = (totalLikes ?? 0) + 1
        } else {
            totalLikes = (totalLikes ?? 1) - 1
        }
        
        return isLiked
    }
    
    func updateSave() -> Bool {
        isSave = !isSave
        
        if isSave {
            totalSaves = (totalSaves ?? 0) + 1
        } else {
            totalSaves = (totalSaves ?? 1) - 1
        }
        
        return isSave
    }
    
    func updateUse() -> Bool {
        isUsed = !isUsed
        return isUsed
    }
    
    func imageCount() -> Int {
        if let image = image, let urls = image.urls{
            return urls.count
        }
        return 0
    }
    
    func currentStep() -> DealPayStep? {
        if let steps = steps {
            var tempCurrentStep = DealPayStep()
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
    
    func firstStep() -> DealPayStep? {
        if let steps = steps {
            if let step = steps.first {
                return step
            }
            
        }
        return nil
    }
}
