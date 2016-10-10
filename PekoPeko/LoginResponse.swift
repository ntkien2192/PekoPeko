//
//  User.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 10/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum LoginStep: String {
    case input = "input"
    case update = "update"
    case ready = "ready"
    case verify = "verify"
}

enum LoginResponseFields: String {
    case UserID = "_id"
    case FacebookConnected = "facebook_connected"
    case Avatar = "avatar"
    case Cover = "cover"
    case Step = "step"
    case LoginType = "type"
    case FullName = "full_name"
}

class LoginResponse: NSObject {
    
    var userID: String?
    var isFacebookConnected: Bool?
    var avatarUrl: String?
    var coverUrl: String?
    var step: LoginStep?
    var type: String?
    var fullName: String?
    
    required init(json: JSON) {
        userID = json[LoginResponseFields.UserID.rawValue].string
        isFacebookConnected = json[LoginResponseFields.FacebookConnected.rawValue].boolValue
        avatarUrl = json[LoginResponseFields.Avatar.rawValue].string
        let stepString = json[LoginResponseFields.Step.rawValue].stringValue

        if stepString == LoginStep.input.rawValue {
            step = .input
        } else if stepString == LoginStep.update.rawValue {
            step = .update
        } else if stepString == LoginStep.ready.rawValue {
            step = .ready
        } else if stepString == LoginStep.verify.rawValue {
            step = .verify
        }
        
        type = json[LoginResponseFields.UserID.rawValue].string
        fullName = json[LoginResponseFields.FullName.rawValue].string
    }
}
