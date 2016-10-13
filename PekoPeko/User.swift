//
//  User.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 10/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

enum LoginStep: String {
    case input = "input"
    case update = "update"
    case ready = "ready"
    case verify = "verify"
}

enum UserFields: String {
    case UserID = "_id"
    case FacebookConnected = "facebook_connected"
    case Avatar = "avatar"
    case Cover = "cover"
    case Step = "step"
    case LoginType = "type"
    case FullName = "full_name"
}

class User: Mappable {
    
    var userID: String?
    var isFacebookConnected: Bool?
    var avatarUrl: String?
    var coverUrl: String?
    var step: LoginStep?
    var type: String?
    var fullName: String?
    
    required init(json: JSON) {
        userID = json[UserFields.UserID.rawValue].string
        isFacebookConnected = json[UserFields.FacebookConnected.rawValue].boolValue
        avatarUrl = json[UserFields.Avatar.rawValue].string
        let stepString = json[UserFields.Step.rawValue].stringValue

        if stepString == LoginStep.input.rawValue {
            step = .input
        } else if stepString == LoginStep.update.rawValue {
            step = .update
        } else if stepString == LoginStep.ready.rawValue {
            step = .ready
        } else if stepString == LoginStep.verify.rawValue {
            step = .verify
        }
        
        type = json[UserFields.UserID.rawValue].string
        fullName = json[UserFields.FullName.rawValue].string
    }

    required init?(map: Map) {}
    func mapping(map: Map) {
        fullName <- map[UserFields.FullName.rawValue]
    }
}
