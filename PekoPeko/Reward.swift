//
//  Reward.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 15/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum RewardFields: String {
    case RewardID = "reward_id"
    case Redeemed = "redeemed"
    case Title = "title"
    case Desc = "desc"
    case HPRequire = "hp_require"
    case HPCurrent = "hp_current"
    case CanRedeem = "can_redeem"
    case Image = "image"
}

class Reward: NSObject {
    var rewardID: String?
    var isRedeemed: Bool?
    var title: String?
    var desc: String?
    var hpRequire: Int?
    var hpCurrent: Int?
    var isCanRedeem: Bool?
    var imageUrl: String?
    
    required init(json: JSON) {
        rewardID = json[RewardFields.RewardID.rawValue].string
        isRedeemed = json[RewardFields.Redeemed.rawValue].bool
        title = json[RewardFields.Title.rawValue].string
        desc = json[RewardFields.Desc.rawValue].string
        hpRequire = json[RewardFields.HPRequire.rawValue].int
        hpCurrent = json[RewardFields.HPCurrent.rawValue].int
        isCanRedeem = json[RewardFields.CanRedeem.rawValue].bool
        imageUrl = json[RewardFields.Image.rawValue].string
    }
}
