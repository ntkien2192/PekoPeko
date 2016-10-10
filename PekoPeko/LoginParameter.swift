//
//  DeviceParameter.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 10/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper

enum LoginType: String {
    case phone = "phone"
    case facebook = "facebook"
}

enum LoginParameterFields: String {
    case Password = "password"
    case Phone = "phone"
    case DeviceId = "device_id"
    case Location = "location"
    case Code = "code"
    case LoginType = "type"
}

class LoginParameter: Mappable {
    var phone: String?
    var password: String?
    var deviceId: String?
    var location: Location?
    var code: String?
    var loginType: String?
    
    init(phone: String, password: String, location: Location) {
        self.phone = phone
        self.password = password
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            self.deviceId = identifierForVendor.uuidString
        }
        self.location = location
    }
    
    init(phone: String, code: String, location: Location) {
        self.phone = phone
        self.code = code
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            self.deviceId = identifierForVendor.uuidString
        }
        self.loginType = "phone"
        self.location = location
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        phone <- map[LoginParameterFields.Phone.rawValue]
        password <- map[LoginParameterFields.Password.rawValue]
        deviceId <- map[LoginParameterFields.DeviceId.rawValue]
        location <- map[LoginParameterFields.Location.rawValue]
        code <- map[LoginParameterFields.Code.rawValue]
        loginType <- map[LoginParameterFields.LoginType.rawValue]
    }
}
