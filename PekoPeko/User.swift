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

//"email": "vng_tun@hotmail.com",
//"username": "",
//"gender": "1",
//"avatar": "users/57105c43a2b7a7480141ddcc/avatar.jpg",
//"cover": "users/57105c43a2b7a7480141ddcc/cover.jpg",
//"promo_code": "6DQJRK",
//"birthday": "436936387667",
//"type": 1,
//"phone": "",
//"points": "0",
//"followers": "67",
//"followings": "298"

enum UserFields: String {
    case UserID = "_id"
    case FacebookConnected = "facebook_connected"
    case Avatar = "avatar"
    case Cover = "cover"
    case Step = "step"
    case LoginType = "type"
    case FullName = "full_name"
    
    // Base Data
    case Email = "email"
    case Gender = "gender"
    case PromoCode = "promo_code"
    case Birthday = "birthday"
    case Phone = "phone"
    case Points = "points"
    case Followers = "followers"
    case Followings = "followings"
}

class User: Mappable {
    
    var userID: String?
    var isFacebookConnected: Bool?
    var avatarUrl: String?
    var coverUrl: String?
    var step: LoginStep?
    var type: String?
    var fullName: String?
    
    // Base Data
    var email: String?
    var gender: String?
    var promoCode: String?
    var birthday: Date?
    var points: Int?
    var followers: Int?
    var followings: Int?
    
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
        
        // Base Data
        email = json[UserFields.Email.rawValue].string
        gender = json[UserFields.Gender.rawValue].string
        promoCode = json[UserFields.PromoCode.rawValue].string
        let time = json[UserFields.Birthday.rawValue].double
        if let time = time {
            birthday = Date(timeIntervalSince1970: time)
        }
        points = json[UserFields.Points.rawValue].int
        followers = json[UserFields.Followers.rawValue].int
        followings = json[UserFields.Followings.rawValue].int
    }

    required init?(map: Map) {}
    func mapping(map: Map) {
        fullName <- map[UserFields.FullName.rawValue]
    }
}
