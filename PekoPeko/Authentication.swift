//
//  Authentication.swift
//  Gomabu For Restaurant
//
//  Created by Hieu Tran on 3/10/16.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import Foundation
import ObjectMapper


enum AuthParametersFields: String {
    case PhoneNumber = "phoneNumber"
    case Password = "password"
}

struct AuthParameters: Mappable {
    var phoneNumber: String?
    var password: String?

    init(phoneNumber: String, password: String) {
        self.phoneNumber = phoneNumber
        self.password = password
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        phoneNumber    <- map[AuthParametersFields.PhoneNumber.rawValue]
        password    <- map[AuthParametersFields.Password.rawValue]
    }
}
